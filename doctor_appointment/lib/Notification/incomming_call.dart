// lib/widgets/incoming_call_dialog.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment/HomeScreen/ChatScreen/VideoCall_Screen.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class IncomingCallDialog extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String callId;
  final String appointmentId;
  final DateTime appointmentTime;

  const IncomingCallDialog({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.callId,
    required this.appointmentId,
    required this.appointmentTime,
  });

  @override
  State<IncomingCallDialog> createState() => _IncomingCallDialogState();
}

class _IncomingCallDialogState extends State<IncomingCallDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    // Auto reject after 30 seconds
    Future.delayed(Duration(seconds: 30), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: ScaleTransition(
        scale: _scaleAnimation,
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
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.call, size: 50, color: Colors.white),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green.shade100,
                      child: Icon(Icons.person, size: 50, color: Colors.green),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.patientName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Incoming Consultation Call",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 24),

                    // Animated ringing indicator
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
                            icon: Icons.call,
                            label: "Accept",
                            color: Colors.green,
                            onTap: () {
                              Navigator.pop(context);
                              _acceptCall();
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
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.5),
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

  void _acceptCall() {
    // Navigate to video/audio call
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallPage(
          userId: widget.patientId,
          userName: widget.patientName,
          callId: widget.callId,
          endTime: widget.appointmentTime.add(const Duration(minutes: 30)),
          doctorName: widget.patientName,
          doctorImage: "",
          // endTime: widget.appointmentTime.add(const Duration(minutes: 30)),
        ),
      ),
    );
  }

  void _rejectCall() async {
    await FirebaseFirestore.instance
        .collection('call_requests')
        .doc(widget.callId)
        .update({
          'status': 'rejected',
          'rejectedAt': FieldValue.serverTimestamp(),
        });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Call rejected")));
    }
  }
}
