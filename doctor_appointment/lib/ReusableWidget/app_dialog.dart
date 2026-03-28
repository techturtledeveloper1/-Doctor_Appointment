import 'package:doctor_appointment/LoginScreen/NewLogin_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: AlertDialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppImages.logout_dialog,
                height: 70,
                width: 70,
                alignment: Alignment.center,
              ),
              SizedBox(height: 20),
              Text(
                "Logout",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.colorPrimary,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.black, fontSize: 14),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColor.colorPrimary),
                    ),
                    text: "No",
                    textStyle: TextStyle(
                      color: AppColor.colorPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.pop(context);
                      callLogout(context);
                    },
                    text: "Yes",
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> callLogout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Navigator.of(
    context,
  ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreenNew()));
}
