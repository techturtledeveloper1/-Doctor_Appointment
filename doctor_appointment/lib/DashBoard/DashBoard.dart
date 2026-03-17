import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../APIService/ApiService.dart';
import '../AppointmentScreen/Appointment_Screen.dart';
import '../ConsultScreen/Consult_Screen.dart';
import '../HomeScreen/ConsultPsychiatristScreen/ConsultPsychiatrist_Screen.dart';
import '../HomeScreen/Home_screen.dart';
import '../HomeScreen/NewHome_screen.dart';
import '../HomeScreen/OrderMedicineScreen/MedicineCart_Screen.dart';
import '../LoginScreen/Login_screen.dart';
import '../LoginScreen/NewLogin_Screen.dart';
import '../PrescriptionsScreen/Prescriptions_Screen.dart';
import '../PrescriptionsScreen/medicalStore_Screen.dart';
import '../UserProfileScreen/UserProfile_Screen.dart';
import '../Utils/ColorConstant.dart';
import '../Utils/fontutils.dart';

class DashBoardNew extends StatefulWidget {
  int tabIndex;
  String userId;
  List<File>? mediaList = [];
  List? deletedMediaList = [];
  var lat, lng;
  String? locationName;
  var markupText;
  int privacyStatus;
  bool createPost;
  bool editPost;
  String postId;
  int p_status = 0;
  var selectedFeatureListId;
  final Map<String, dynamic>? newAppointment;   // 👈 Add this


  DashBoardNew(this.tabIndex, this.createPost, this.editPost,
      [this.userId = "",
        this.mediaList,
        this.lat,
        this.lng,
        this.locationName,
        this.markupText,
        this.privacyStatus = 0,
        this.deletedMediaList,
        this.postId = "",
        this.selectedFeatureListId,
        this.newAppointment,    // 👈 Add this
      ]);

  @override
  State<DashBoardNew> createState() => _DashBoardNewState();
}

class _DashBoardNewState extends State<DashBoardNew>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _advancedDrawerController = AdvancedDrawerController();

  String profileImage = "", email = "", username = "";
  int tabIndex = 0;
  late PageController pageController;
  bool _isConsultExpanded = false; // add this in your State


  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: ColorConstant.colorIntroBG,
    ));

    tabIndex = widget.tabIndex;
    pageController = PageController(initialPage: tabIndex);
  }

  /// 🔹 Dynamic AppBar for each screen
  AppBar getAppBar() {
    switch (tabIndex) {
      case 0:
        return AppBar(
          backgroundColor: ColorConstant.colorWhite,
          elevation: 0,
          automaticallyImplyLeading: false, // removes back/menu button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// 🔹 Left: Logo + Text
              Row(
                children: [
                  Image.asset(
                    "assets/Images/logo.png", // replace with your app logo
                    height: 40,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Serenest",
                    style: TextStyle(
                      color: ColorConstant.colorIntroBG,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              /// 🔹 Right: Notification + Avatar
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to notifications screen
                    },
                    icon: Icon(
                      Icons.notifications_none,
                      color: ColorConstant.colorIntroBG,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage("assets/Images/d1.png"),
                  ),
                ],
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, size: 29.0, color: ColorConstant.colorIntroBG),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 1:
        return AppBar(
          backgroundColor: ColorConstant.colorWhite,
          title: Text("Appointments",style: TextStyle(color: ColorConstant.colorIntroBG),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, size: 29.0, color: ColorConstant.colorIntroBG),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 2:
        return AppBar(
          backgroundColor: ColorConstant.colorWhite,
          title: Text("Consult",style: TextStyle(color: ColorConstant.colorIntroBG)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, size: 29.0, color: ColorConstant.colorIntroBG),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 3:
        // return AppBar(
        //   backgroundColor: ColorConstant.colorWhite,
        //   title: Text("Medical Store",style: TextStyle(color: ColorConstant.colorIntroBG)),
        //   centerTitle: true,
        //   leading: IconButton(
        //     icon: Icon(Icons.menu_rounded, size: 29.0, color: ColorConstant.colorIntroBG),
        //     onPressed: () => _advancedDrawerController.showDrawer(),
        //   ),
        // );
        return AppBar(
          backgroundColor: ColorConstant.colorWhite,
          title: Text(
            "Order Medicines",
            style: TextStyle(color: ColorConstant.colorIntroBG),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, size: 29.0, color: ColorConstant.colorIntroBG),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),

          /// ✅ RIGHT SIDE CART BUTTON
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined, color: ColorConstant.colorIntroBG, size: 26),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicineCartScreen(),  // ✅ Navigate to Cart Screen
                  ),
                );
              },
            ),
          ],
        );
      case 4:
        return AppBar(
          backgroundColor: ColorConstant.colorWhite,
          title: Text("Profile",style: TextStyle(color: ColorConstant.colorIntroBG)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, size: 29.0, color: ColorConstant.colorIntroBG),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      default:
        return AppBar(
          backgroundColor: ColorConstant.colorWhite,
          title: Text("Doctor Appointment",style: TextStyle(color: ColorConstant.colorIntroBG)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded, size: 29.0, color: ColorConstant.colorIntroBG),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Images/bg_nav_drawer.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: true,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: getAppBar(), // 🔹 Dynamic AppBar
          bottomNavigationBar: bottomNav(),
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (v) {
              setState(() {
                tabIndex = v;
              });
            },
            children: [
              NewhomeScreen(),
              AppointmentCalendarScreen(),
              ConsultScreen(
                doctorName: 'Dr. Priya Sharma',
                specialty: 'Cardiologist',
                // mode: 'Video Call',
                appointmentTime: DateTime.parse("2025-09-15 10:30:00"),
                hospital: 'Mercy Hospital',
                location: 'Ahmedabad , gujarat',
                image: '',
              ),
              MedicalStoreListScreen(),
              // PrescriptionsScreen(),
              ProfileScreen(),
            ],
          ),
        ),
        drawer: SafeArea(
          child: Container(
            child: menuItem(),
          ),
        ),
      ),
    );
  }

  Widget menuItem() {
    return Scaffold(
      body: Container(
        color: ColorConstant.colorWhite, // 🔹 Drawer Background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: profileImage.isEmpty
                    ? const AssetImage("assets/Images/d1.png")
                    : CachedNetworkImageProvider(ApiService.imageurl + profileImage)
                as ImageProvider,
              ),
              title: Text(
                "jay Patel",
                style: TextStyle(
                    color: ColorConstant.colorIntroBG, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "jaypatel123@Gmail.com",
                style: TextStyle(color: ColorConstant.colorIntroBG),
              ),
            ),
            Divider(color: ColorConstant.colorIntroBG),
            drawerItem("Home", Icons.home, 0),
            drawerItem("Appointments", Icons.calendar_today, 1),

            /// 🔹 Collapsible Consult
            ExpansionTile(
              leading: Icon(Icons.medical_services,
                  color: ColorConstant.colorIntroBG),
              title: Text("Consult",
                  style: TextStyle(color: ColorConstant.colorIntroBG)),
              initiallyExpanded: false,
              trailing: Icon(
                _isConsultExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: ColorConstant.colorIntroBG,
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  _isConsultExpanded = expanded;
                });
              },
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: ColorConstant.colorIntroBG),
                  title: Text("Psychiatrist",
                      style: TextStyle(color: ColorConstant.colorIntroBG)),
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const ConsultPsychiatristScreen(specializationId: '',)),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.psychology, color: ColorConstant.colorIntroBG),
                  title: Text("Psychologist",
                      style: TextStyle(color: ColorConstant.colorIntroBG)),
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.healing, color: ColorConstant.colorIntroBG),
                  title: Text("Therapist",
                      style: TextStyle(color: ColorConstant.colorIntroBG)),
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                  },
                ),
              ],
            ),

            drawerItem("Prescriptions", Icons.description, 3),
            drawerItem("Profile", Icons.person, 4),
            drawerItem("Settings", Icons.settings, 5), // Added Settings
            drawerItem("Help & Support", Icons.help_outline, 6), // Added Help & Support
            drawerItem("Logout", Icons.logout, -1, isLogout: true),
          ],
        ),
      ),
    );
  }


  Widget drawerItem(String title, IconData icon, int index,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: ColorConstant.colorIntroBG),
      title: Text(title, style: TextStyle(color : ColorConstant.colorIntroBG)),
      onTap: () {
        _advancedDrawerController.hideDrawer();
        if (isLogout) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreenNew()),
          );
        } else {
          setState(() {
            tabIndex = index;
            pageController.jumpToPage(tabIndex);
          });
        }
      },
    );
  }

  Widget bottomNav() {
    return CircleNavBar(
      activeIcons: [
        Image.asset("assets/Icons/home.png", height: 30, color: ColorConstant.colorIntroBG),
        Icon(Icons.calendar_month, size: 20.0, color: ColorConstant.colorIntroBG),
        // Image.asset("assets/icons/calendar_filled.png", height: 28, color: ColorConstant.colorIntroBG),
        Image.asset("assets/Icons/consult.png", height: 30, color: ColorConstant.colorIntroBG),
        Image.asset("assets/Icons/medicine.png", height: 30, color: ColorConstant.colorIntroBG),
        Image.asset("assets/Icons/profile.png", height: 30, color: ColorConstant.colorIntroBG),
      ],
      inactiveIcons: [
        Image.asset("assets/Icons/home1.png", height: 50, color: ColorConstant.colorIntroBG),
        Icon(Icons.calendar_today_outlined, size: 20.0, color: ColorConstant.colorIntroBG),
        // Image.asset("assets/icons/calendar.png", height: 28, color: ColorConstant.colorIntroBG),
        Image.asset("assets/Icons/consult1.png", height: 50, color: ColorConstant.colorIntroBG),
        Image.asset("assets/Icons/medicine1.png", height: 50, color: ColorConstant.colorIntroBG),
        Image.asset("assets/Icons/profile1.png", height: 50, color: ColorConstant.colorIntroBG),
      ],
      color: ColorConstant.colorWhite,
      height: 60,
      circleWidth: 55,
      activeIndex: tabIndex,
      onTap: (index) {
        setState(() {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        });
      },
      shadowColor: Colors.white,
      elevation: 4,
    );
  }

  // Widget bottomNav() {
  //   return CircleNavBar(
  //     activeIcons: [
  //       _navItem("assets/Icons/home.png", "Home"),
  //       _navItem("assets/Icons/calendar.png", "Calendar"),
  //       _navItem("assets/Icons/consult.png", "Consult"),
  //       _navItem("assets/Icons/medicine.png", "Medicine"),
  //       _navItem("assets/Icons/profile.png", "Profile"),
  //     ],
  //     inactiveIcons: [
  //       _navItem("assets/Icons/home1.png", "Home"),
  //       _navItem("assets/Icons/calendar1.png", "Calendar"),
  //       _navItem("assets/Icons/consult1.png", "Consult"),
  //       _navItem("assets/Icons/medicine1.png", "Medicine"),
  //       _navItem("assets/Icons/profile1.png", "Profile"),
  //     ],
  //     color: ColorConstant.colorWhite,
  //     height: 65,
  //     circleWidth: 55,
  //     activeIndex: tabIndex,
  //     onTap: (index) {
  //       setState(() {
  //         tabIndex = index;
  //         pageController.jumpToPage(tabIndex);
  //       });
  //     },
  //     shadowColor: Colors.white,
  //     elevation: 4,
  //   );
  // }
  //
  // /// Helper widget for icon + label
  // Widget _navItem(String assetPath, String label) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Image.asset(assetPath, height: 24, color: ColorConstant.colorIntroBG),
  //       const SizedBox(height: 2),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 10,
  //           fontWeight: FontWeight.w500,
  //           color: ColorConstant.colorIntroBG,
  //         ),
  //       ),
  //     ],
  //   );
  // }



  Future<void> callLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
    );
  }
}
