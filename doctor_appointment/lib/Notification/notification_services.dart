// // lib/services/notification_service.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     // Initialize for Android
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings();
//
//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(settings);
//
//     // Request permissions
//     await FirebaseMessaging.instance.requestPermission();
//
//     // Get FCM token
//     String? token = await FirebaseMessaging.instance.getToken();
//     print("📱 FCM Token: $token");
//
//     // Listen to messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
//
//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
//   void _handleForegroundMessage(RemoteMessage message) async {
//     print("📨 Received foreground message: ${message.notification?.title}");
//
//     // Show local notification
//     await showLocalNotification(
//       title: message.notification?.title ?? "New Appointment",
//       body: message.notification?.body ?? "You have a new appointment request",
//       payload: message.data,
//     );
//   }
//
//   void _handleMessageOpened(RemoteMessage message) {
//     print("📱 Notification tapped");
//     // Navigate based on notification data
//     if (message.data.isNotEmpty) {
//       // Handle navigation
//     }
//   }
//
//   Future<void> showLocalNotification({
//     required String title,
//     required String body,
//     Map<String, dynamic>? payload,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'appointment_channel',
//           'Appointment Notifications',
//           channelDescription: 'Notifications for new appointments and calls',
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           sound: RawResourceAndroidNotificationSound('notification_sound'),
//           enableVibration: true,
//           fullScreenIntent: true,
//         );
//
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch.remainder(100000),
//       title,
//       body,
//       details,
//       payload: payload?.toString(),
//     );
//   }
//
//   // Show incoming call notification with action buttons
//   Future<void> showIncomingCallNotification({
//     required String callId,
//     required String patientName,
//     required String patientId,
//     required String appointmentId,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'call_channel',
//           'Call Notifications',
//           channelDescription: 'Incoming call notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           sound: RawResourceAndroidNotificationSound('ringtone'),
//           enableVibration: true,
//           fullScreenIntent: true,
//           ongoing: true,
//           autoCancel: false,
//         );
//
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       categoryIdentifier: 'incoming_call',
//     );
//
//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch.remainder(100000),
//       "Incoming Call",
//       "$patientName is calling you for consultation",
//       details,
//       payload:
//           '{"callId": "$callId", "patientId": "$patientId", "appointmentId": "$appointmentId"}',
//     );
//   }
// }
//
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling background message: ${message.messageId}");
//   // Handle background message
// }
// notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> showIncomingCallNotification({
    required String title,
    required String body,
    required String callId,
    required String callType,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'calls_channel',
          'Calls',
          channelDescription: 'Incoming call notifications',
          importance: Importance.high,
          priority: Priority.high,
          fullScreenIntent: true,
          ongoing: true,
          autoCancel: false,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: 'call_$callId',
    );
  }
}
