import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class AppColor {
  static Color white = Color(0xFFFFFFFF);
  static Color black = Color(0xFF000000);

  // Main App Theme (Teal/Green from screenshot)
  // static final colorIntroBG = Color(0xFF195C65); // AppBar / primary
  static Color colorIntroBG = Color(0xFF004D56); // AppBar / primary
  static Color colorPrimary = Color(0xFF195C65);
  static const Color colorSecondary = Color(0xFF144A52);

  static Color colorAccent = Color(0xFF2BB9A5); // can use for highlights

  static Color colorTextWelcome = Color(0xFF7D7D7D); // grey text
  static Color textColor1 = Color(0xFF333333);
  static Color textColor2 = Color(0xFFc8e2e2);

  static Color colorInactiveIcon = Color(0xFF7D7D7D);
  static Color hintColor = Color(0xFFB9B9B9);

  static Color borderColourslider = Color(0xFF707070);
  static Color borderColorOTP = Color(0xFFD6D6D6);

  static Color activeBorderColor = Color(0xFF4285F6);
  static Color inactiveBoderColor = Color(0xFFD6D6D6);
  static Color errorBorderColor = Color(0xFFFE3C01);
  static Color deviderColour = Color(0xFF707070);
  static Color deviderColour2 = Color(0xFFD6D6D6);

  static Color errorIconColor = Color(0xFFB20025);
  static Color grey50 = Color(0xFFB4B4B4);
  static Color grey = Colors.grey;

  static Color eventDeclinedcolor = Color(0xFFD9284D);
  static Color eventJoindedcolor = Color(0xFFB9B9B9);
  static Color eventExpiredBgcolor = Color(0xFFDB1840);
  static Color acceptedTextcolor = Color(0xFF007500);
  static Color rejectFriendRequestNotification = Color(0xFFD9284D);

  static int comment_count_feed = 0;
  static bool isCreatepost = false;
  static List imageList = [];
  static var postItem;
  static List postFeature = [];
  static List createpostSelectedFeatureList = [];
  static int postPrivay = 0;
  static bool isEditPost = false;
  static List editedPhotos = [];
  static String editedPostLocation = "";
  static double editedPostLat = 0.0;
  static double editedPostLng = 0.0;
  static String editedPostUserId = "";
  static String editedPostmarkuptext = "";
  static int editedPostprivacy = 0;
  static List editpostdeletedMediaList = [];
  static List editpostselectedFeatureIds = [];

  static String postId = "";
  static ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);

  static List indi_Name = ['Bartender', 'Server', 'Entertainment'];
  static List business_Name = ['Bar', 'Winery', 'Brewery', 'Other'];

  static Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
  }
}
