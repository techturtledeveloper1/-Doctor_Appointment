import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoiceCallScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;
  const VoiceCallScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Call - ${doctor['name']}"),
        backgroundColor: AppColor.colorPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.call, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Voice Call in Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.call_end),
              label: const Text("End Call"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
