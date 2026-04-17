// lib/services/call_service.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/HomeScreen/model/call_model.dart';

class CallService {
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<DocumentSnapshot>? _callSubscription;
  Timer? _expiryTimer;

  // Callbacks for doctor side
  Function(CallModel)? onCallAccepted;
  Function()? onCallRejected;
  Function()? onCallExpired;
  Function(String)? onCallError;

  // Create a new outgoing call (Doctor Side)
  Future<String> initiateCall({
    required String doctorId,
    required String doctorName,
    required String doctorImage,
    required String patientId,
    required String patientName,
    required String patientImage,
    required String appointmentId,
    required DateTime appointmentTime,
    required String callType,
  }) async {
    try {
      final String callId = appointmentId; // Use appointmentId as callId
      final DateTime expiryTime = DateTime.now().add(
        const Duration(seconds: 45),
      );

      final callData = {
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorImage': doctorImage,
        'patientId': patientId,
        'patientName': patientName,
        'patientImage': patientImage,
        'appointmentId': appointmentId,
        'appointmentTime': Timestamp.fromDate(appointmentTime),
        'callType': callType,
        'status': 'ringing',
        'initiatedBy': 'doctor',
        'initiatedAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(expiryTime),
      };

      await _firestore.collection('call_requests').doc(callId).set(callData);

      print("✅ Call initiated with ID: $callId");
      print("📞 Patient will receive notification for status: ringing");

      // Start listening for patient's response
      _listenForCallResponse(callId);

      // Set auto-expiry
      _startExpiryTimer(callId);

      return callId;
    } catch (e) {
      print("❌ Failed to initiate call: $e");
      onCallError?.call(e.toString());
      rethrow;
    }
  }

  // Listen for patient's response (Doctor Side)
  void _listenForCallResponse(String callId) {
    _callSubscription?.cancel();

    _callSubscription = _firestore
        .collection('call_requests')
        .doc(callId)
        .snapshots()
        .listen(
          (snapshot) {
            if (!snapshot.exists) return;

            final data = snapshot.data() as Map<String, dynamic>;
            final status = data['status'];

            print("📞 Call status updated: $status");

            switch (status) {
              case 'accepted':
                _cleanup();
                if (onCallAccepted != null) {
                  onCallAccepted!(CallModel.fromFirestore(data, callId));
                }
                break;
              case 'rejected':
                _cleanup();
                onCallRejected?.call();
                break;
              case 'expired':
                _cleanup();
                onCallExpired?.call();
                break;
            }
          },
          onError: (error) {
            print("🔥 Firestore stream error: $error");
            onCallError?.call(error.toString());
          },
        );
  }

  // Auto-expiry timer
  void _startExpiryTimer(String callId) {
    _expiryTimer?.cancel();

    _expiryTimer = Timer(const Duration(seconds: 45), () async {
      try {
        final doc = await _firestore
            .collection('call_requests')
            .doc(callId)
            .get();

        if (doc.exists && doc.data()?['status'] == 'ringing') {
          await _firestore.collection('call_requests').doc(callId).update({
            'status': 'expired',
            'expiredAt': FieldValue.serverTimestamp(),
          });
          print("⏰ Call expired automatically");
          onCallExpired?.call();
        }
      } catch (e) {
        print("❌ Error expiring call: $e");
      }
    });
  }

  // Cancel call (Doctor Side)
  Future<void> cancelCall(String callId) async {
    try {
      await _firestore.collection('call_requests').doc(callId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
      print("🚫 Call cancelled: $callId");
      _cleanup();
    } catch (e) {
      print("❌ Error cancelling call: $e");
    }
  }

  // Accept call (Patient Side)
  Future<void> acceptCall(String callId) async {
    try {
      await _firestore.collection('call_requests').doc(callId).update({
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });
      print("✅ Call accepted: $callId");
    } catch (e) {
      print("❌ Error accepting call: $e");
      rethrow;
    }
  }

  // Reject call (Patient Side)
  Future<void> rejectCall(String callId) async {
    try {
      await _firestore.collection('call_requests').doc(callId).update({
        'status': 'rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });
      print("❌ Call rejected: $callId");
    } catch (e) {
      print("❌ Error rejecting call: $e");
    }
  }

  // Listen for incoming calls (Patient Side)
  Stream<CallModel> listenForIncomingCalls(String patientId) {
    return _firestore
        .collection('call_requests')
        .where('patientId', isEqualTo: patientId)
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .expand((snapshot) => snapshot.docChanges)
        .where((change) => change.type == DocumentChangeType.added)
        .map(
          (change) => CallModel.fromFirestore(
            change.doc.data() as Map<String, dynamic>,
            change.doc.id,
          ),
        );
  }

  // Get call details
  Future<CallModel?> getCallDetails(String callId) async {
    try {
      final doc = await _firestore
          .collection('call_requests')
          .doc(callId)
          .get();
      if (doc.exists) {
        return CallModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print("❌ Error getting call details: $e");
      return null;
    }
  }

  void _cleanup() {
    _callSubscription?.cancel();
    _expiryTimer?.cancel();
    _callSubscription = null;
    _expiryTimer = null;
  }

  void dispose() {
    _cleanup();
    onCallAccepted = null;
    onCallRejected = null;
    onCallExpired = null;
    onCallError = null;
  }
}
