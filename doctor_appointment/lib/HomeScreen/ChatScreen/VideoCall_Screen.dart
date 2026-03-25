import 'package:doctor_appointment/PrescriptionsScreen/Prescriptions_Screen.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class VideoCallScreen extends StatefulWidget {
//   final String doctorName;
//   final String specialty;
//
//   const VideoCallScreen({
//     super.key,
//     required this.doctorName,
//     required this.specialty,
//   });
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   bool isMuted = false;
//   bool isVideoOff = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           /// Doctor's video (Main Screen)
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: Colors.teal[100],
//             child: Center(
//               child: Icon(Icons.person, size: 120, color: Colors.teal[700]),
//             ),
//           ),
//
//           /// Header with Doctor Name & Specialty
//           SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 12),
//                 Center(
//                   child: Text(
//                     widget.doctorName,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   widget.specialty,
//                   style: const TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//                 const Text(
//                   "Video Call",
//                   style: TextStyle(fontSize: 15, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//
//           /// User thumbnail video (bottom-left)
//           Positioned(
//             bottom: 110,
//             left: 16,
//             child: Container(
//               width: 100,
//               height: 140,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.teal, width: 2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Center(
//                 child: Icon(Icons.person, size: 50, color: Colors.teal),
//               ),
//             ),
//           ),
//
//           /// Bottom Controls
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 40),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   /// Mute Button
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundColor: Colors.teal,
//                     child: IconButton(
//                       icon: Icon(
//                         isMuted ? Icons.mic_off : Icons.mic,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isMuted = !isMuted;
//                         });
//                       },
//                     ),
//                   ),
//
//                   /// Video On/Off
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundColor: Colors.teal,
//                     child: IconButton(
//                       icon: Icon(
//                         isVideoOff ? Icons.videocam_off : Icons.videocam,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isVideoOff = !isVideoOff;
//                         });
//                       },
//                     ),
//                   ),
//
//                   /// Chat Button
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundColor: Colors.teal,
//                     child: IconButton(
//                       icon: const Icon(Icons.chat, color: Colors.white),
//                       onPressed: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Open Chat clicked")),
//                         );
//                       },
//                     ),
//                   ),
//
//                   /// End Call
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundColor: Colors.red,
//                     child: IconButton(
//                       icon: const Icon(Icons.call_end, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const PrescriptionScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class VideoCallPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String callId;

  const VideoCallPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.callId,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool isMicOn = true;
  bool isCameraOn = true;
  bool isSpeakerOn = true;

  final int appID = 1334081427;
  final String appSign =
      "a34e019fe6a04ea93b51b588b3f628a1eb7ee348ed69aab76ab819dfbcf2badc";

  @override
  Widget build(BuildContext context) {
    final config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
      ..bottomMenuBarConfig.isVisible = true
      ..bottomMenuBarConfig.buttons = [
        ZegoCallMenuBarButtonName.toggleCameraButton,
        ZegoCallMenuBarButtonName.switchCameraButton,
        ZegoCallMenuBarButtonName.hangUpButton,
        ZegoCallMenuBarButtonName.switchAudioOutputButton,
        ZegoCallMenuBarButtonName.toggleMicrophoneButton,
        ZegoCallMenuBarButtonName.showMemberListButton,
        // ZegoCallMenuBarButtonName.chatButton,
        // ZegoCallMenuBarButtonName.toggleScreenSharingButton,
        // ZegoCallMenuBarButtonName.beautyEffectButton,
        // ZegoCallMenuBarButtonName.soundEffectButton,
        // ZegoCallMenuBarButtonName.pipButton,
        // ZegoCallMenuBarButtonName.minimizingButton,
      ];

    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: appID,
          appSign: appSign,
          userID: widget.userId,
          userName: widget.userName,
          callID: widget.callId,
          config: config,
        ),
      ),
    );
  }
}
