import 'dart:async';
import 'package:doctor_appointment/Utils/ColorConstant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../HomeScreen/ChatScreen/Chat_Screen.dart';
import '../HomeScreen/ChatScreen/VideoCall_Screen.dart';

class ConsultScreen extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String hospital;
  final String location;
  final DateTime appointmentTime;
  final String image;

  const ConsultScreen({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.location,
    required this.appointmentTime,
    required this.image,
  });

  @override
  State<ConsultScreen> createState() => _ConsultScreenState();
}

class _ConsultScreenState extends State<ConsultScreen> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeLeft();
    });
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    setState(() {
      _timeLeft = widget.appointmentTime.difference(now);
      if (_timeLeft.isNegative) _timeLeft = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedCountdown {
    final hours = _timeLeft.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = _timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours != "00" ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final canJoin = _timeLeft <= Duration.zero;

    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.black87),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Doctor Info
            CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage("assets/Images/d2.png")
                  // : NetworkImage("assets/Images/d1.png") as ImageProvider,
            ),
            const SizedBox(height: 12),
            Text(
              widget.doctorName,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: ColorConstant.colorIntroBG),
            ),
            Text(
              widget.specialty,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              "${widget.hospital} • ${widget.location}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            /// Appointment Date & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18, color: ColorConstant.colorIntroBG),
                const SizedBox(width: 6),
                Text(DateFormat('dd MMM yyyy').format(widget.appointmentTime),
                    style: TextStyle(fontSize: 16,color: ColorConstant.colorIntroBG)),
                const SizedBox(width: 20),
                Icon(Icons.access_time, size: 18, color: ColorConstant.colorIntroBG),
                const SizedBox(width: 6),
                Text(DateFormat('hh:mm a').format(widget.appointmentTime),
                    style: TextStyle(fontSize: 16,color: ColorConstant.colorIntroBG)),
              ],
            ),
            const SizedBox(height: 25),

            /// Countdown
            if (!canJoin)
              Column(
                children: [
                  Text(
                    "Join available in",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.colorIntroBG),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      _formattedCountdown,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),

            /// Action Buttons
            if (canJoin) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Joining Video Call...")));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoCallScreen(
                        doctorName: widget.doctorName,
                        specialty: widget.specialty,
                      ),
                    ),
                  );
                },
                child: Text("Join Video Call",
                    style: TextStyle(color: ColorConstant.colorWhite)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Joining Audio Call...")));
                },
                child: Text("Join Audio Call",style: TextStyle(color: ColorConstant.colorIntroBG),),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(doctorName: widget.doctorName),
                    ),
                  );
                },
                child: Text("Open Chat",style: TextStyle(color: ColorConstant.colorIntroBG),),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Upload Prescription or Notes clicked")));
                },
                icon: const Icon(Icons.upload_file, size: 18),
                label: Text("Upload Prescription or Notes",style: TextStyle(color: ColorConstant.colorIntroBG),),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              /// Reschedule & Cancel
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Reschedule Appointment clicked")));
                },
                child: const Text("Reschedule Appointment",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Cancel Appointment clicked")));
                },
                child: const Text("Cancel Appointment",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent)),
              ),
              const SizedBox(height: 20),
              Text(
                "You will receive a reminder 15 minutes before your session.",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
