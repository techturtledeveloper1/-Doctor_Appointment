// active_call_screen.dart
import 'package:doctor_appointment/ConsultScreen/call_manager.dart';
import 'package:flutter/material.dart';

class ActiveCallScreen extends StatelessWidget {
  final String callId;
  final String callType;
  final String peerName;
  final bool isCaller;

  const ActiveCallScreen({
    super.key,
    required this.callId,
    required this.callType,
    required this.peerName,
    required this.isCaller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallManager.buildCallScreen(
        callId: callId,
        callType: callType,
        userID: CallManager.currentUserId ?? "",
        userName: CallManager.currentUserName ?? "",
        isCaller: isCaller,
      ),
    );
  }
}
