import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/LoginScreen/NewLogin_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_dialog.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:doctor_appointment/screen/profile_screen/MyPayments/MyPayment_Screen.dart';
import 'package:doctor_appointment/screen/profile_screen/MyPrescriptions/MyPrescriptions_Screen.dart';
import 'package:doctor_appointment/screen/profile_screen/PersonalDetailsScreen/PersonalDetails_Screen.dart';
import 'package:doctor_appointment/screen/profile_screen/Settings/Settings_Screen.dart';
import 'package:doctor_appointment/screen/profile_screen/address_screen/address_screen.dart';
import 'package:doctor_appointment/screen/profile_screen/help_support/help_support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyOrder/MyOrders_Screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;
  String imageUrl = "";

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() => isLoading = true);

    try {
      var response = await ApiService().callGetProfileApi();

      if (response != null && response["success"] == true) {
        var data;

        if (response["data"] != null &&
            response["data"] is List &&
            response["data"].isNotEmpty) {
          data = response["data"][0];
        } else if (response["user"] != null) {
          data = response["user"];
        }

        if (data != null) {
          setState(() {
            username = data["fullName"] ?? "";
            email = data["userDetails"]?["email"] ?? "";
            imageUrl = data["profile_photo"] ?? "";
            isLoading = false;
          });
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Profile error: $e");
      setState(() => isLoading = false);
    }
  }

  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.person, "title": "Personal Details"},
    {"icon": Icons.medical_services, "title": "My Prescriptions"},
    {"icon": Icons.shopping_bag, "title": "My Orders"},
    {"icon": Icons.credit_card, "title": "Payments"},
    {"icon": Icons.location_on, "title": "My Address"},
    {"icon": Icons.settings, "title": "Settings"},
    {"icon": Icons.help_outline, "title": "Help & Support"},
    {"icon": Icons.logout, "title": "Logout"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 50, color: AppColor.textColor2)
                  : null,
              backgroundColor: AppColor.white,
            ),
            SizedBox(height: 15),
            Text(
              username ?? "No User Name",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.colorIntroBG,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  email ?? "No Email",
                  style: TextStyle(fontSize: 16, color: AppColor.colorIntroBG),
                ),
              ],
            ),
            SizedBox(height: 30),

            /// Menu
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: menuItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                var item = menuItems[index];
                return InkWell(
                  onTap: () {
                    switch (item['title']) {
                      case "Personal Details":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalDetailsScreen(),
                          ),
                        ).then((_) {
                          loadProfile(); // 🔥 refresh after back
                        });
                        break;
                      case "My Prescriptions":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyPrescriptionsScreen(),
                          ),
                        );
                        break;
                      case "My Orders":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrdersScreen(),
                          ),
                        );
                        break;
                      case "Payments":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(),
                          ),
                        );
                        break;
                      case "My Address":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddressListScreen(),
                          ),
                        );
                        break;
                      case "Settings":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                        break;
                      case "Help & Support":
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => HelpSupportScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                        break;
                      case "Logout":
                        showLogoutDialog(context);
                        break;
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.deviderColour2),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.white,
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'], color: AppColor.colorPrimary),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.colorPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: AppColor.colorPrimary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
