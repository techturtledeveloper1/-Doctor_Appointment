// lib/services/appointment_notification_listener.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/Notification/incomming_call.dart';
import 'package:doctor_appointment/Notification/notification_services.dart';
import 'package:flutter/material.dart';

class AppointmentNotificationListener {
  static final AppointmentNotificationListener _instance =
      AppointmentNotificationListener._internal();
  factory AppointmentNotificationListener() => _instance;
  AppointmentNotificationListener._internal();

  StreamSubscription? _appointmentSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // void startListening(String doctorId, BuildContext context) {
  //   _appointmentSubscription = _firestore
  //       .collection('appointments')
  //       .where('doctorId', isEqualTo: doctorId)
  //       .where('status', isEqualTo: 'pending')
  //       .snapshots()
  //       .listen((snapshot) {
  //         for (var doc in snapshot.docChanges) {
  //           if (doc.type == DocumentChangeType.added) {
  //             final appointment = doc.data();
  //             _showAppointmentNotification(context, appointment, doc.id);
  //           }
  //         }
  //       });
  //
  //   _firestore
  //       .collection('call_requests')
  //       .where('doctorId', isEqualTo: doctorId)
  //       .where('status', isEqualTo: 'ringing')
  //       .snapshots()
  //       .listen((snapshot) {
  //         for (var doc in snapshot.docChanges) {
  //           if (doc.type == DocumentChangeType.added) {
  //             final callRequest = doc.data();
  //             _showIncomingCallNotification(context, callRequest, doc.id);
  //           }
  //         }
  //       });
  // }
  // If your data is nested differently
  void startListening(String doctorId, BuildContext context) {
    _appointmentSubscription = _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          for (var docChange in snapshot.docChanges) {
            if (docChange.type == DocumentChangeType.added) {
              // Safe way to get data
              final doc = docChange.doc;
              final Map<String, dynamic>? data =
                  doc.data() as Map<String, dynamic>?;

              if (data != null) {
                final appointment = data;
                final appointmentId = doc.id;
                _showAppointmentNotification(
                  context,
                  appointment,
                  appointmentId,
                );
              }
            }
          }
        });
  }

  void _showAppointmentNotification(
    BuildContext context,
    Map<String, dynamic> appointment,
    String appointmentId,
  ) {
    DateTime appointmentTime;
    if (appointment['appointmentTime'] is Timestamp) {
      appointmentTime = (appointment['appointmentTime'] as Timestamp).toDate();
    } else if (appointment['appointmentTime'] is String) {
      appointmentTime = DateTime.parse(appointment['appointmentTime']);
    } else {
      appointmentTime = DateTime.now();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.blue),
            SizedBox(width: 10),
            Text("New Appointment Request"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Patient: ${appointment['patientName']}"),
            SizedBox(height: 5),
            Text("Time: ${appointment['appointmentTime']}"),
            SizedBox(height: 5),
            Text("Mode: ${appointment['mode']?.toString().toUpperCase()}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Later", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _acceptAppointment(appointmentId, appointment);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Accept", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // Also show local notification
    NotificationService().showLocalNotification(
      title: "New Appointment",
      body:
          "${appointment['patientName']} booked a ${appointment['mode']} consultation",
    );
  }

  void _showIncomingCallNotification(
    BuildContext context,
    Map<String, dynamic> callRequest,
    String callId,
  ) {
    DateTime appointmentTime;
    if (callRequest['appointmentTime'] is Timestamp) {
      appointmentTime = (callRequest['appointmentTime'] as Timestamp).toDate();
    } else if (callRequest['appointmentTime'] is String) {
      appointmentTime = DateTime.parse(callRequest['appointmentTime']);
    } else {
      appointmentTime = DateTime.now();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => IncomingCallDialog(
        patientName: callRequest['patientName'],
        patientId: callRequest['patientId'],
        callId: callId,
        appointmentId: callRequest['appointmentId'],
        appointmentTime: appointmentTime,
      ),
    );
  }

  void _acceptAppointment(
    String appointmentId,
    Map<String, dynamic> appointment,
  ) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'confirmed',
      'doctorAcceptedAt': FieldValue.serverTimestamp(),
    });
  }

  void stopListening() {
    _appointmentSubscription?.cancel();
  }
}
