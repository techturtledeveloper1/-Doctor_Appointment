import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../DashBoard/DashBoard.dart';
import '../ProfileScreen/ProfileSetup_Screen.dart';
import '../ResetPassword/NewPassword_screen.dart';
import '../Utils/ColorConstant.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  final String flow; // "login", "forgot", "signup"

  const OtpScreen({super.key, required this.mobile, required this.flow});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = "";
  late Timer _timer;
  int _start = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _verifyOtp() {
    Widget nextScreen;
    switch (widget.flow) {
      case "login":
        nextScreen = DashBoardNew(0, false, false);
        break;
      case "forgot":
        nextScreen = const ResetPasswordScreen();
        break;
      case "signup":
        nextScreen = const ProfileSetupScreen();
        break;
      default:
        nextScreen = DashBoardNew(0, false, false);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      body: SafeArea(
        child: SingleChildScrollView( // ✅ fixes overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // --- Logo ---
                Image.asset("assets/Images/logo.png", height: 150),
                const SizedBox(height: 20),

                // --- Heading ---
                Text(
                  "Verify Your Number",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.colorIntroBG,
                  ),
                ),
                const SizedBox(height: 30),

                // --- OTP Boxes ---
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  onChanged: (value) => setState(() => otp = value),
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 45,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: ColorConstant.colorIntroBG,
                    selectedColor: ColorConstant.colorIntroBG,
                    inactiveColor: Colors.grey.shade400,
                  ),
                  enableActiveFill: true,
                ),

                const SizedBox(height: 10),

                // --- Timer ---
                Text(
                  "00:${_start.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 20),

                // --- Resend OTP ---
                GestureDetector(
                  onTap: () {
                    if (_start == 0) {
                      startTimer();
                      // TODO: call resend OTP API
                    }
                  },
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _start == 0
                          ? ColorConstant.colorIntroBG
                          : Colors.grey.shade400,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // --- Change Number ---
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Change Number",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // --- Verify & Continue Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: ColorConstant.colorIntroBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: otp.length == 6 ? _verifyOtp : null,
                    child: const Text(
                      "Verify & Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// firbase connect

// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
//
// import '../DashBoard/DashBoard.dart';
// import '../ProfileScreen/ProfileSetup_Screen.dart';
// import '../ResetPassword/NewPassword_screen.dart';
// import '../Utils/ColorConstant.dart';
//
// class OtpScreen extends StatefulWidget {
//   final String mobile;
//   final String flow; // "login", "forgot", "signup"
//   final String verificationId; // 👈 Firebase verificationId
//
//   const OtpScreen({
//     super.key,
//     required this.mobile,
//     required this.flow,
//     required this.verificationId,
//   });
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   String otp = "";
//   late Timer _timer;
//   int _start = 30;
//   bool _loading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   void startTimer() {
//     _start = 30;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         _timer.cancel();
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   Future<void> _verifyOtp() async {
//     setState(() => _loading = true);
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: otp,
//       );
//
//       UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(credential);
//
//       if (userCredential.user != null) {
//         Widget nextScreen;
//         switch (widget.flow) {
//           case "login":
//             nextScreen = DashBoardNew(0, false, false);
//             break;
//           case "forgot":
//             nextScreen = const ResetPasswordScreen();
//             break;
//           case "signup":
//             nextScreen = const ProfileSetupScreen();
//             break;
//           default:
//             nextScreen = DashBoardNew(0, false, false);
//         }
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => nextScreen),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid OTP. Please try again.")),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstant.colorWhite,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),
//
//                 // --- Logo ---
//                 Image.asset("assets/Images/logo.png", height: 150),
//                 const SizedBox(height: 20),
//
//                 // --- Heading ---
//                 Text(
//                   "Verify Your Number",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: ColorConstant.colorIntroBG,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//
//                 // --- OTP Boxes ---
//                 PinCodeTextField(
//                   appContext: context,
//                   length: 6,
//                   onChanged: (value) => setState(() => otp = value),
//                   keyboardType: TextInputType.number,
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.box,
//                     borderRadius: BorderRadius.circular(8),
//                     fieldHeight: 50,
//                     fieldWidth: 45,
//                     activeFillColor: Colors.white,
//                     inactiveFillColor: Colors.white,
//                     selectedFillColor: Colors.white,
//                     activeColor: ColorConstant.colorIntroBG,
//                     selectedColor: ColorConstant.colorIntroBG,
//                     inactiveColor: Colors.grey.shade400,
//                   ),
//                   enableActiveFill: true,
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // --- Timer ---
//                 Text(
//                   "00:${_start.toString().padLeft(2, '0')}",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // --- Resend OTP ---
//                 GestureDetector(
//                   onTap: () {
//                     if (_start == 0) {
//                       startTimer();
//                       // TODO: Call Firebase resend OTP (verifyPhoneNumber again)
//                     }
//                   },
//                   child: Text(
//                     "Resend OTP",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _start == 0
//                           ? ColorConstant.colorIntroBG
//                           : Colors.grey.shade400,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // --- Change Number ---
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Text(
//                     "Change Number",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 40),
//
//                 // --- Verify & Continue Button ---
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       backgroundColor: ColorConstant.colorIntroBG,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     onPressed: otp.length == 6 && !_loading ? _verifyOtp : null,
//                     child: _loading
//                         ? const CircularProgressIndicator(
//                         color: Colors.white, strokeWidth: 2)
//                         : const Text(
//                       "Verify & Continue",
//                       style:
//                       TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
