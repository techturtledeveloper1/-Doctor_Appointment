// lib/services/call_notification_sender.dart
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/HomeScreen/ChatScreen/VideoCall_Screen.dart';
import 'package:doctor_appointment/HomeScreen/ChatScreen/VoiceCall_Screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// class CallNotificationSender {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//
//   final String _serverKey = 'YOUR_SERVER_KEY_HERE';
//
//   Future<void> sendCallRequest({
//     required String doctorId,
//     required String patientId,
//     required String patientName,
//     required String appointmentId,
//     required String callType,
//     required DateTime appointmentTime,
//   }) async {
//     final doctorDoc = await _firestore
//         .collection('doctors')
//         .doc(doctorId)
//         .get();
//     final doctorToken = doctorDoc.data()?['fcmToken'];
//
//     if (doctorToken != null && doctorToken.isNotEmpty) {
//       // Send FCM notification
//       final response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=YOUR_SERVER_KEY_HERE',
//         },
//         body: jsonEncode({
//           'to': doctorToken,
//           'notification': {
//             'title': 'Incoming Call',
//             'body': '$patientName is calling you',
//             'sound': 'ringtone',
//           },
//           'data': {
//             'callId': appointmentId,
//             'patientId': patientId,
//             'patientName': patientName,
//             'appointmentId': appointmentId,
//             'type': callType,
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//           },
//           'priority': 'high',
//         }),
//       );
//
//       print("📤 FCM Response: ${response.body}");
//     }
//
//     // Save call request to Firestore
//     await _firestore.collection('call_requests').add({
//       'doctorId': doctorId,
//       'patientId': patientId,
//       'patientName': patientName,
//       'appointmentId': appointmentId,
//       'callType': callType,
//       'status': 'ringing',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }
// }
// lib/services/call_notification_sender.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// class CallNotificationSender {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//
//   // Replace with your Firebase Cloud Messaging server key
//   final String _serverKey = 'YOUR_SERVER_KEY_HERE';
//
//   Future<void> sendCallRequest({
//     required String doctorId,
//     required String patientId,
//     required String patientName,
//     required String appointmentId,
//     required String callType, // 'video' or 'audio'
//     required DateTime appointmentTime,
//   }) async {
//     try {
//       // Get doctor's FCM token
//       final doctorDoc = await _firestore
//           .collection('doctors')
//           .doc(doctorId)
//           .get();
//       final doctorToken = doctorDoc.data()?['fcmToken'];
//
//       if (doctorToken != null && doctorToken.isNotEmpty) {
//         // Send FCM notification
//         await _sendFCMNotification(
//           token: doctorToken,
//           title: 'Incoming Call',
//           body: '$patientName is calling you',
//           data: {
//             'callId': appointmentId,
//             'patientId': patientId,
//             'patientName': patientName,
//             'appointmentId': appointmentId,
//             'type': callType,
//             'appointmentTime': appointmentTime.toIso8601String(),
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//           },
//         );
//       }
//
//       await _firestore.collection('call_requests').add({
//         'doctorId': doctorId,
//         'patientId': patientId,
//         'patientName': patientName,
//         'appointmentId': appointmentId,
//         'callType': callType,
//         'appointmentTime': Timestamp.fromDate(appointmentTime),
//         'status': 'ringing',
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       print("📤 Call request sent successfully");
//     } catch (e) {
//       print("❌ Error sending call request: $e");
//     }
//   }
//
//   Future<void> _sendFCMNotification({
//     required String token,
//     required String title,
//     required String body,
//     required Map<String, String> data,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$_serverKey',
//         },
//         body: jsonEncode({
//           'to': token,
//           'notification': {
//             'title': title,
//             'body': body,
//             'sound': 'ringtone', // This will play the ringtone
//             'priority': 'high',
//             'channel_id': 'call_channel',
//           },
//           'data': data,
//           'priority': 'high',
//         }),
//       );
//
//       print("📤 FCM Response: ${response.statusCode}");
//       print("📤 FCM Body: ${response.body}");
//     } catch (e) {
//       print("❌ FCM Error: $e");
//     }
//   }
//
//   Future<void> updateCallStatus(String callId, String status) async {
//     await _firestore.collection('call_requests').doc(callId).update({
//       'status': status,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }
// }

class PatientCallListener {
  static final PatientCallListener _instance = PatientCallListener._internal();
  factory PatientCallListener() => _instance;
  PatientCallListener._internal();

  StreamSubscription? _callSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void startListening(String patientId, BuildContext context) {
    print("📱 Starting patient call listener for: $patientId");

    _callSubscription = _firestore
        .collection('call_requests')
        .where('patientId', isEqualTo: patientId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          for (var docChange in snapshot.docChanges) {
            if (docChange.type == DocumentChangeType.added) {
              final doc = docChange.doc;
              final Map<String, dynamic>? data =
                  doc.data() as Map<String, dynamic>?;

              if (data != null) {
                print("📞 Incoming call from doctor: ${data['doctorName']}");
                _showIncomingCallDialog(context, data, doc.id);
              }
            }
          }
        });
  }

  void _showIncomingCallDialog(
    BuildContext context,
    Map<String, dynamic> callRequest,
    String callId,
  ) {
    // Parse appointment time
    DateTime appointmentTime;
    if (callRequest['appointmentTime'] is Timestamp) {
      appointmentTime = (callRequest['appointmentTime'] as Timestamp).toDate();
    } else if (callRequest['appointmentTime'] is String) {
      appointmentTime = DateTime.parse(callRequest['appointmentTime']);
    } else {
      appointmentTime = DateTime.now();
    }

    // Show dialog only if context is valid
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PatientIncomingCallDialog(
          doctorName: callRequest['doctorName'] ?? 'Doctor',
          doctorId: callRequest['doctorId'] ?? '',
          callId: callId,
          appointmentId: callRequest['appointmentId'] ?? '',
          appointmentTime: appointmentTime,
          callType: callRequest['callType'] ?? 'video',
        ),
      );
    }
  }

  void stopListening() {
    _callSubscription?.cancel();
  }
}

// Patient Incoming Call Dialog
class PatientIncomingCallDialog extends StatefulWidget {
  final String doctorName;
  final String doctorId;
  final String callId;
  final String appointmentId;
  final DateTime appointmentTime;
  final String callType;

  const PatientIncomingCallDialog({
    super.key,
    required this.doctorName,
    required this.doctorId,
    required this.callId,
    required this.appointmentId,
    required this.appointmentTime,
    required this.callType,
  });

  @override
  State<PatientIncomingCallDialog> createState() =>
      _PatientIncomingCallDialogState();
}

class _PatientIncomingCallDialogState extends State<PatientIncomingCallDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  Timer? _autoRejectTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Auto reject after 30 seconds
    _autoRejectTimer = Timer(Duration(seconds: 30), () {
      if (mounted) {
        _rejectCall();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoRejectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top colored bar
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Icon(
                    widget.callType == 'video' ? Icons.videocam : Icons.call,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.doctorName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Incoming ${widget.callType.toUpperCase()} Call",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Appointment at ${_formatTime(widget.appointmentTime)}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 24),

                  // Ringing indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRingingDot(),
                      SizedBox(width: 8),
                      _buildRingingDot(delay: 0.3),
                      SizedBox(width: 8),
                      _buildRingingDot(delay: 0.6),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.call_end,
                          label: "Decline",
                          color: Colors.red,
                          onTap: () {
                            _rejectCall();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _buildActionButton(
                          icon: widget.callType == 'video'
                              ? Icons.videocam
                              : Icons.call,
                          label: "Accept",
                          color: Colors.green,
                          onTap: () {
                            _acceptCall();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRingingDot({double delay = 0}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2 * value,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _acceptCall() async {
    // Update call status in Firestore
    await FirebaseFirestore.instance
        .collection('call_requests')
        .doc(widget.callId)
        .update({
          'status': 'accepted',
          'acceptedAt': FieldValue.serverTimestamp(),
        });

    // Navigate to call screen
    if (context.mounted) {
      if (widget.callType == 'video') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoCallPage(
              userId: widget.doctorId,
              userName: widget.doctorName,
              callId: widget.callId,
              endTime: widget.appointmentTime.add(const Duration(minutes: 30)),
              doctorName: widget.doctorName,
              doctorImage: "",
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VoiceCallPage(
              userId: widget.doctorId,
              userName: widget.doctorName,
              callId: widget.callId,
            ),
          ),
        );
      }
    }
  }

  void _rejectCall() async {
    await FirebaseFirestore.instance
        .collection('call_requests')
        .doc(widget.callId)
        .update({
          'status': 'rejected',
          'rejectedAt': FieldValue.serverTimestamp(),
        });
  }
}
