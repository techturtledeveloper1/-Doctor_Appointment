import 'dart:async';
import 'dart:io';

import 'package:doctor_appointment/PrescriptionsScreen/Prescriptions_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallPage extends StatefulWidget {
  final String userId;
  final String userName;
  final String callId;
  final DateTime endTime;

  const VideoCallPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.callId,
    required this.endTime,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool isMicOn = true;
  bool isCameraOn = true;
  bool isSpeakerOn = true;
  Timer? _endCallTimer;
  String _avgRating = "0";

  final int appID = 1334081427;
  final String appSign =
      "a34e019fe6a04ea93b51b588b3f628a1eb7ee348ed69aab76ab819dfbcf2badc";
  @override
  void initState() {
    super.initState();
    startAutoEndTimer();
  }

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

  void startAutoEndTimer() {
    final now = DateTime.now();
    final difference = widget.endTime.difference(now);

    if (difference.isNegative) {
      endCall();
    } else {
      _endCallTimer = Timer(difference, () {
        endCall();
      });
    }
  }

  void endCall() {
    if (mounted) {
      Navigator.pop(context); // 🔴 Close call screen

      Future.delayed(const Duration(milliseconds: 300), () {
        _showRatingDialog();
      });
    }
  }

  void _showRatingDialog() {
    double rating = 0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getEmoji(rating), style: TextStyle(fontSize: 50)),
                        const SizedBox(height: 10),
                        Text(
                          getTitle(rating),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          getSubtitle(rating),
                          textAlign: TextAlign.center,
                        ), // Text(

                        const SizedBox(height: 15),

                        // ⭐ Stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () async {
                                rating = index + 1.0;

                                setStateDialog(() {}); // dialog UI update

                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                  'doctor_rating',
                                  rating.toString(),
                                );

                                // ✅ UPDATE MAIN UI
                                if (mounted) {
                                  setState(() {
                                    _avgRating = rating.toString();
                                  });
                                }

                                // ✅ CLOSE DIALOG SAFELY
                                Navigator.of(dialogContext).pop();
                              },
                              icon: Icon(
                                Icons.star,
                                color: index < rating
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                                size: 30,
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 15),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            onPressed: () {
                              _openPlayStore();
                            },

                            text: "Rate on Google Play",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.close, size: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getEmoji(double rating) {
    if (rating <= 1) return "😞";
    if (rating == 2) return "🙂";
    if (rating == 3) return "😇";
    if (rating == 4) return "😊";
    return "🤩";
  }

  String getTitle(double rating) {
    if (rating <= 1) return "Poor Experience";
    if (rating == 2) return "Needs Improvement";
    if (rating == 3) return "Average Experience";
    if (rating == 4) return "Good Consultation";
    return "Excellent Care!";
  }

  String getSubtitle(double rating) {
    if (rating <= 1) {
      return "We’re sorry your consultation didn’t go well. Please tell us what went wrong.";
    }
    if (rating == 2) {
      return "Your feedback helps us improve doctor services and patient care.";
    }
    if (rating == 3) {
      return "Thanks! Let us know how we can make your experience better.";
    }
    if (rating == 4) {
      return "We're glad you had a good consultation experience.";
    }
    return "Thank you for trusting our doctors. Stay healthy! ❤️";
  }

  void _openPlayStore() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid
          ? 'com.serenest.doctor_app'
          : 'com.serenest.doctor_app';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _endCallTimer?.cancel();
    super.dispose();
  }
}
