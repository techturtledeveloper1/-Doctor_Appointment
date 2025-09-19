import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DashBoard/DashBoard.dart';
import '../IntroScreen/IntroScreen.dart';
import '../Utils/ColorConstant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isLogin = false;

  @override
  void initState() {
    super.initState();
    // checkSession();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          // isLogin!
          //     ?
          // DashBoardNew(2, false, false) // 👈 your dashboard
               const IntroScreen(),          // 👈 your intro/login screen
        ),
      );
    });
  }

  // Future<void> checkSession() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool("isLogin") != null) {
  //     isLogin = prefs.getBool("isLogin");
  //     if (isLogin!) {
  //       ColorConstant.token = prefs.getString("myToken") ?? "";
  //     }
  //   } else {
  //     isLogin = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Primary brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/Images/logo.png', // 👈 put your logo here
              height: 600,
            ),
            const SizedBox(height: 30),

            // App Name
            const Text(
              "Doctor Appointment",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            const Text(
              "Your health, our priority",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 40),

            // Progress Indicator
            // const CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            // ),
          ],
        ),
      ),
    );
  }
}
