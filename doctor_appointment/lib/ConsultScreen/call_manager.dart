// call_manager.dart (Fixed)
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:audioplayers/audioplayers.dart';

class CallManager {
  static final CallManager _instance = CallManager._internal();
  factory CallManager() => _instance;
  CallManager._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String? currentUserId;
  static String? currentUserName;
  static String? currentUserRole;

  static Function(Map<String, dynamic>)? onIncomingCall;
  static Function(String, String)? onCallConnected;
  static Function(String)? onCallDisconnected;
  static Function(String)? onCallRejected;
  static Function(String)? onCallExpired;

  StreamSubscription<QuerySnapshot>? _callSubscription;
  AudioPlayer? _ringtonePlayer;
  Timer? _ringtoneTimer;
  String? _activeCallId;

  // Store active subscriptions to cancel them properly
  final Map<String, StreamSubscription<DocumentSnapshot>>
  _callResponseSubscriptions = {};

  // Store expiry timers
  final Map<String, Timer> _expiryTimers = {};

  // Zego Credentials
  static const int appID = 1334081427;
  static const String appSign =
      "a34e019fe6a04ea93b51b588b3f628a1eb7ee348ed69aab76ab819dfbcf2badc";

  void init({
    required String userId,
    required String userName,
    required String userRole,
  }) {
    currentUserId = userId;
    currentUserName = userName;
    currentUserRole = userRole;
    _listenForIncomingCalls();
    print("✅ CallManager initialized for: $userName ($userRole)");
  }

  void _listenForIncomingCalls() {
    if (currentUserId == null) return;

    _callSubscription?.cancel();

    _callSubscription = _firestore
        .collection('call_requests')
        .where('peerId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .listen(
          (snapshot) {
            for (var docChange in snapshot.docChanges) {
              if (docChange.type == DocumentChangeType.added) {
                final callData = docChange.doc.data() as Map<String, dynamic>;
                callData['callId'] = docChange.doc.id;
                _handleIncomingCall(callData);
              }
            }
          },
          onError: (error) {
            print("❌ Call listener error: $error");
          },
        );
  }

  void _handleIncomingCall(Map<String, dynamic> callData) {
    print("📞 Incoming call from: ${callData['callerName']}");
    _playRingtone();

    if (onIncomingCall != null) {
      onIncomingCall!(callData);
    }
  }

  Future<void> _playRingtone() async {
    _ringtonePlayer = AudioPlayer();
    try {
      await _ringtonePlayer!.setSourceAsset('assets/sounds/ringing.mp3');
      await _ringtonePlayer!.setReleaseMode(ReleaseMode.loop);
      await _ringtonePlayer!.setVolume(1.0);
      await _ringtonePlayer!.resume();
      print("🔊 Ringtone playing");
    } catch (e) {
      print("❌ Error playing ringtone: $e");
    }
  }

  Future<void> _stopRingtone() async {
    if (_ringtonePlayer != null) {
      await _ringtonePlayer!.stop();
      await _ringtonePlayer!.dispose();
      _ringtonePlayer = null;
      print("🔊 Ringtone stopped");
    }
  }

  Future<String> makeCall({
    required String peerId,
    required String peerName,
    required String callType,
    required String appointmentId,
    required DateTime appointmentTime,
  }) async {
    if (currentUserId == null) throw Exception("CallManager not initialized");

    final String callId =
        'call_${DateTime.now().millisecondsSinceEpoch}_$appointmentId';
    final DateTime expiryTime = DateTime.now().add(const Duration(seconds: 45));

    await _firestore.collection('call_requests').doc(callId).set({
      'callId': callId,
      'callerId': currentUserId,
      'callerName': currentUserName,
      'peerId': peerId,
      'peerName': peerName,
      'appointmentId': appointmentId,
      'appointmentTime': Timestamp.fromDate(appointmentTime),
      'callType': callType,
      'status': 'ringing',
      'initiatedBy': currentUserRole,
      'initiatedAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expiryTime),
    });

    print("✅ Call initiated: $callId");

    _scheduleCallExpiry(callId);
    _listenForCallResponse(callId, callType);

    return callId;
  }

  void _scheduleCallExpiry(String callId) {
    final timer = Timer(const Duration(seconds: 45), () async {
      final doc = await _firestore
          .collection('call_requests')
          .doc(callId)
          .get();
      if (doc.exists && doc.data()?['status'] == 'ringing') {
        await _firestore.collection('call_requests').doc(callId).update({
          'status': 'expired',
          'expiredAt': FieldValue.serverTimestamp(),
        });
        if (onCallExpired != null) onCallExpired!(callId);
        _stopRingtone();
        _cleanupCall(callId);
      }
    });
    _expiryTimers[callId] = timer;
  }

  void _listenForCallResponse(String callId, String callType) {
    final subscription = _firestore
        .collection('call_requests')
        .doc(callId)
        .snapshots()
        .listen((snapshot) {
          if (!snapshot.exists) {
            _cleanupCall(callId);
            return;
          }

          final data = snapshot.data() as Map<String, dynamic>;
          final status = data['status'];

          print("📞 Call status for $callId: $status");

          if (status == 'accepted') {
            _cleanupCall(callId);
            if (onCallConnected != null) onCallConnected!(callId, callType);
          } else if (status == 'rejected') {
            _cleanupCall(callId);
            if (onCallRejected != null) onCallRejected!(callId);
          } else if (status == 'expired') {
            _cleanupCall(callId);
            if (onCallExpired != null) onCallExpired!(callId);
          } else if (status == 'ended') {
            _cleanupCall(callId);
            if (onCallDisconnected != null) onCallDisconnected!(callId);
          }
        });

    _callResponseSubscriptions[callId] = subscription;
  }

  void _cleanupCall(String callId) {
    _callResponseSubscriptions[callId]?.cancel();
    _callResponseSubscriptions.remove(callId);
    _expiryTimers[callId]?.cancel();
    _expiryTimers.remove(callId);
  }

  Future<void> acceptCall(String callId) async {
    await _stopRingtone();

    final doc = await _firestore.collection('call_requests').doc(callId).get();
    final callData = doc.data() as Map<String, dynamic>;

    await _firestore.collection('call_requests').doc(callId).update({
      'status': 'accepted',
      'acceptedAt': FieldValue.serverTimestamp(),
      'acceptedBy': currentUserId,
    });

    if (onCallConnected != null) {
      onCallConnected!(callId, callData['callType'] ?? 'video');
    }
  }

  Future<void> rejectCall(String callId) async {
    await _stopRingtone();
    _cleanupCall(callId);

    await _firestore.collection('call_requests').doc(callId).update({
      'status': 'rejected',
      'rejectedAt': FieldValue.serverTimestamp(),
      'rejectedBy': currentUserId,
    });
  }

  Future<void> endCall(String callId) async {
    final doc = await _firestore.collection('call_requests').doc(callId).get();
    if (doc.exists) {
      await _firestore.collection('call_requests').doc(callId).update({
        'status': 'ended',
        'endedAt': FieldValue.serverTimestamp(),
      });
    }
    _cleanupCall(callId);
    if (onCallDisconnected != null) onCallDisconnected!(callId);
  }

  void dispose() {
    _callSubscription?.cancel();
    _stopRingtone();
    _ringtoneTimer?.cancel();

    // Cleanup all active calls
    for (var callId in _callResponseSubscriptions.keys) {
      _cleanupCall(callId);
    }
  }

  static Widget buildCallScreen({
    required String callId,
    required String callType,
    required String userID,
    required String userName,
    required bool isCaller,
  }) {
    if (callType == 'video') {
      return ZegoUIKitPrebuiltCall(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        callID: callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..turnOnCameraWhenJoining = true
          ..turnOnMicrophoneWhenJoining = true,
        // ..onCallEnd =
        //     (
        //       context,
        //       callID,
        //       callEndReason,
        //       internalUserID,
        //       internalUserName,
        //     ) {
        //       // Corrected parameters
        //       print("📞 Call ended: $callID, reason: $callEndReason");
        //       CallManager().endCall(callID);
        //     },
      );
    } else {
      return ZegoUIKitPrebuiltCall(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        callID: callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
          ..turnOnCameraWhenJoining = false
          ..turnOnMicrophoneWhenJoining = true
          ..useSpeakerWhenJoining = true,
        // ..onCallEnd =
        //     (
        //       context,
        //       callID,
        //       callEndReason,
        //       internalUserID,
        //       internalUserName,
        //     ) {
        //       // Corrected parameters
        //       print("📞 Call ended: $callID, reason: $callEndReason");
        //       CallManager().endCall(callID);
        //     },
      );
    }
  }
}
