import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class AppColor {

  static final white = Color(0xFFFFFFFF);
  static final colorBlack = Color(0xFF000000);

  // Main App Theme (Teal/Green from screenshot)
  // static final colorIntroBG = Color(0xFF195C65); // AppBar / primary
  static final colorIntroBG = Color(0xFF004D56); // AppBar / primary
  static final colorPrimary = Color(0xFF195C65);
  static final colorAccent = Color(0xFF2BB9A5); // can use for highlights

  static final colorTextWelcome = Color(0xFF7D7D7D); // grey text
  static final textColor1 = Color(0xFF333333);
  static final textColor2 = Color(0xFFc8e2e2);

  static final colorInactiveIcon = Color(0xFF7D7D7D);
  static final hintColor = Color(0xFFB9B9B9);

  static final borderColourslider = Color(0xFF707070);
  static final borderColorOTP = Color(0xFFD6D6D6);

  static final activeBorderColor = Color(0xFF4285F6);
  static final inactiveBoderColor = Color(0xFFD6D6D6);
  static final errorBorderColor = Color(0xFFFE3C01);
  static final deviderColour = Color(0xFF707070);
  static final deviderColour2 = Color(0xFFD6D6D6);

  static final errorIconColor = Color(0xFFB20025);

  static final eventDeclinedcolor = Color(0xFFD9284D);
  static final eventJoindedcolor = Color(0xFFB9B9B9);
  static final eventExpiredBgcolor = Color(0xFFDB1840);
  static final acceptedTextcolor = Color(0xFF007500);
  static final rejectFriendRequestNotification = Color(0xFFD9284D);

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
  static ValueNotifier<int> notificationCounterValueNotifer =
  ValueNotifier(0);

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
