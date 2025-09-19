import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utils/ColorConstant.dart';

class VideoCallScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;
  const VideoCallScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Call - ${doctor['name']}"),
        backgroundColor: ColorConstant.colorIntroBG,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: Icon(Icons.videocam, size: 120, color: Colors.white54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.mic_off),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
