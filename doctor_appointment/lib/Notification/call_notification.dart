// lib/services/call_notification_sender.dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

class CallNotificationSender {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Replace with your Firebase Cloud Messaging server key
  final String _serverKey = 'YOUR_SERVER_KEY_HERE';

  Future<void> sendCallRequest({
    required String doctorId,
    required String patientId,
    required String patientName,
    required String appointmentId,
    required String callType, // 'video' or 'audio'
    required DateTime appointmentTime,
  }) async {
    try {
      // Get doctor's FCM token
      final doctorDoc = await _firestore
          .collection('doctors')
          .doc(doctorId)
          .get();
      final doctorToken = doctorDoc.data()?['fcmToken'];

      if (doctorToken != null && doctorToken.isNotEmpty) {
        // Send FCM notification
        await _sendFCMNotification(
          token: doctorToken,
          title: 'Incoming Call',
          body: '$patientName is calling you',
          data: {
            'callId': appointmentId,
            'patientId': patientId,
            'patientName': patientName,
            'appointmentId': appointmentId,
            'type': callType,
            'appointmentTime': appointmentTime.toIso8601String(),
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
        );
      }

      await _firestore.collection('call_requests').add({
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': patientName,
        'appointmentId': appointmentId,
        'callType': callType,
        'appointmentTime': Timestamp.fromDate(appointmentTime),
        'status': 'ringing',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("📤 Call request sent successfully");
    } catch (e) {
      print("❌ Error sending call request: $e");
    }
  }

  Future<void> _sendFCMNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': title,
            'body': body,
            'sound': 'ringtone', // This will play the ringtone
            'priority': 'high',
            'channel_id': 'call_channel',
          },
          'data': data,
          'priority': 'high',
        }),
      );

      print("📤 FCM Response: ${response.statusCode}");
      print("📤 FCM Body: ${response.body}");
    } catch (e) {
      print("❌ FCM Error: $e");
    }
  }

  Future<void> updateCallStatus(String callId, String status) async {
    await _firestore.collection('call_requests').doc(callId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
