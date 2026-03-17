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
    checkSession();
  }

  Future<void> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if user is logged in
    if (prefs.getBool("isLogin") != null) {
      isLogin = prefs.getBool("isLogin");

      // If logged in, get the token
      if (isLogin!) {
        ColorConstant.token = prefs.getString("myToken") ?? "";

        // Navigate to Dashboard after checking login
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashBoardNew(0, false, false),
            ),
          );
        });
      } else {
        // Not logged in, go to Intro/Login screen
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const IntroScreen(),
            ),
          );
        });
      }
    } else {
      // First time user, go to Intro screen
      isLogin = false;
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const IntroScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // Use your existing color constant
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/Images/logo.png',
              height: 600, // Reduced height for better proportion
              width: 600,
            ),
            const SizedBox(height: 30),

            // App Name
            const Text(
              "SERENEST", // Updated app name to match your main.dart
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

            // Progress Indicator - show while checking login status
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}