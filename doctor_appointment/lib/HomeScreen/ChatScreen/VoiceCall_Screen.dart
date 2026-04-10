import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

Future<void> requestPermissions() async {
  await Permission.microphone.request();
}

class VoiceCallPage extends StatelessWidget {
  final String userId;
  final String userName;
  final String callId; // same ID for both users

  VoiceCallPage({
    required this.userId,
    required this.userName,
    required this.callId,
  });

  final int appID = 1334081427;
  final String appSign =
      "a34e019fe6a04ea93b51b588b3f628a1eb7ee348ed69aab76ab819dfbcf2badc";

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: appID,
      appSign: appSign,
      userID: userId,
      userName: userName,

      callID: callId,
      token:
          "04AAAAAGnCKFUADMNm2HssJ/ZMprsivwC0VVNGFWLjykaU3D3e5fKACbP3bJiG2QTpRSUS3uO5x00sz9V5yiKAkRIH9eWcag9cmXpsBT5+APZm+UO268wpVK8H7HGfB8vAuaPrwiNRs97HN/rkibMUq43I8BCuRs/PS83Qm8UrpazYecUYCwkUxq8e/ytKVnMK6NSsxGgv/sNa2WfJfsm1Y8LppBSvw0sW36q2z0SHmb4oftADIySfVkBlW1kJN0Do2o2S9dW6oirp0CsuAQ==",
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..turnOnCameraWhenJoining = false
        ..turnOnCameraWhenJoining = false
        ..turnOnMicrophoneWhenJoining = true
        ..useSpeakerWhenJoining = true,
    );
  }
}
