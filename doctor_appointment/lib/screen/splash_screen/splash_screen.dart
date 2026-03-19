import 'dart:async';
import 'package:doctor_appointment/screen/DashBoard/DashBoard.dart';
import 'package:doctor_appointment/IntroScreen/IntroScreen.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:doctor_appointment/ReusableWidget/app_string.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

    if (prefs.getBool("isLogin") != null) {
      isLogin = prefs.getBool("isLogin");

      if (isLogin!) {
        AppStrings.token = prefs.getString("myToken") ?? "";

        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashBoardNew(0, false, false),
            ),
          );
        });
      } else {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IntroScreen()),
          );
        });
      }
    } else {
      isLogin = false;
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.logo, height: 600, width: 600),
              const SizedBox(height: 30),

              const Text(
                "SERENEST",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Your health, our priority",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
