import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
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
import '../screen/UserProfileScreen/UserProfile_Screen.dart';
import '../Utils/AppColor.dart';
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
  final Map<String, dynamic>? newAppointment;

  DashBoardNew(
    this.tabIndex,
    this.createPost,
    this.editPost, [
    this.userId = "",
    this.mediaList,
    this.lat,
    this.lng,
    this.locationName,
    this.markupText,
    this.privacyStatus = 0,
    this.deletedMediaList,
    this.postId = "",
    this.selectedFeatureListId,
    this.newAppointment,
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
  bool _isConsultExpanded = false;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColor.colorIntroBG,
      ),
    );

    tabIndex = widget.tabIndex;
    pageController = PageController(initialPage: tabIndex);
  }

  AppBar getAppBar() {
    switch (tabIndex) {
      case 0:
        return AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          automaticallyImplyLeading: false, // removes back/menu button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/logo.png", // replace with your app logo
                    height: 40,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Serenest",
                    style: TextStyle(
                      color: AppColor.colorIntroBG,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.notifications_none,
                      color: AppColor.colorIntroBG,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage("assets/images/d1.png"),
                  ),
                ],
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorIntroBG,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 1:
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Appointments",
            style: TextStyle(color: AppColor.colorIntroBG),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorIntroBG,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 2:
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Consult",
            style: TextStyle(color: AppColor.colorIntroBG),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorIntroBG,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 3:
        // return AppBar(
        //   backgroundColor: AppColor.white,
        //   title: Text("Medical Store",style: TextStyle(color: AppColor.colorIntroBG)),
        //   centerTitle: true,
        //   leading: IconButton(
        //     icon: Icon(icons.menu_rounded, size: 29.0, color: AppColor.colorIntroBG),
        //     onPressed: () => _advancedDrawerController.showDrawer(),
        //   ),
        // );
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Order Medicines",
            style: TextStyle(color: AppColor.colorIntroBG),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorIntroBG,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),

          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: AppColor.colorIntroBG,
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicineCartScreen()),
                );
              },
            ),
          ],
        );
      case 4:
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Profile",
            style: TextStyle(color: AppColor.colorIntroBG),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorIntroBG,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      default:
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Doctor Appointment",
            style: TextStyle(color: AppColor.colorIntroBG),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorIntroBG,
            ),
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
        backdropColor: AppColor.white,
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/profile.png"),
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
          appBar: getAppBar(),
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
        drawer: SafeArea(child: Container(child: menuItem())),
      ),
    );
  }

  Widget menuItem() {
    return Scaffold(
      body: Container(
        color: AppColor.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: profileImage.isEmpty
                    ? const AssetImage("assets/images/d1.png")
                    : CachedNetworkImageProvider(
                            ApiService.imageurl + profileImage,
                          )
                          as ImageProvider,
              ),
              title: Text(
                "jay Patel",
                style: TextStyle(
                  color: AppColor.colorIntroBG,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "jaypatel123@Gmail.com",
                style: TextStyle(color: AppColor.colorIntroBG),
              ),
            ),
            Divider(color: AppColor.colorIntroBG),
            drawerItem("Home", Icons.home, 0),
            drawerItem("Appointments", Icons.calendar_today, 1),

            /// 🔹 Collapsible Consult
            ExpansionTile(
              leading: Icon(
                Icons.medical_services,
                color: AppColor.colorIntroBG,
              ),
              title: Text(
                "Consult",
                style: TextStyle(color: AppColor.colorIntroBG),
              ),
              initiallyExpanded: false,
              trailing: Icon(
                _isConsultExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColor.colorIntroBG,
              ),
              onExpansionChanged: (expanded) {
                setState(() {
                  _isConsultExpanded = expanded;
                });
              },
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: AppColor.colorIntroBG,
                  ),
                  title: Text(
                    "Psychiatrist",
                    style: TextStyle(color: AppColor.colorIntroBG),
                  ),
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsultPsychiatristScreen(
                          specializationId: '',
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.psychology,
                    color: AppColor.colorIntroBG,
                  ),
                  title: Text(
                    "Psychologist",
                    style: TextStyle(color: AppColor.colorIntroBG),
                  ),
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.healing,
                    color: AppColor.colorIntroBG,
                  ),
                  title: Text(
                    "Therapist",
                    style: TextStyle(color: AppColor.colorIntroBG),
                  ),
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                  },
                ),
              ],
            ),

            drawerItem("Prescriptions", Icons.description, 3),
            drawerItem("Profile", Icons.person, 4),
            drawerItem("Settings", Icons.settings, 5), // Added Settings
            drawerItem(
              "Help & Support",
              Icons.help_outline,
              6,
            ), // Added Help & Support
            drawerItem("Logout", Icons.logout, -1, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(
    String title,
    IconData icon,
    int index, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColor.colorIntroBG),
      title: Text(title, style: TextStyle(color: AppColor.colorIntroBG)),
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
        Image.asset(
          "assets/icons/home.png",
          height: 30,
          color: AppColor.colorIntroBG,
        ),
        Icon(
          Icons.calendar_month,
          size: 20.0,
          color: AppColor.colorIntroBG,
        ),
        // Image.asset("assets/icons/calendar_filled.png", height: 28, color: AppColor.colorIntroBG),
        Image.asset(
          "assets/icons/consult.png",
          height: 30,
          color: AppColor.colorIntroBG,
        ),
        Image.asset(
          "assets/icons/medicine.png",
          height: 30,
          color: AppColor.colorIntroBG,
        ),
        Image.asset(
          "assets/icons/profile.png",
          height: 30,
          color: AppColor.colorIntroBG,
        ),
      ],
      inactiveIcons: [
        Image.asset(
          "assets/icons/home1.png",
          height: 50,
          color: AppColor.colorIntroBG,
        ),
        Icon(
          Icons.calendar_today_outlined,
          size: 20.0,
          color: AppColor.colorIntroBG,
        ),
        // Image.asset("assets/icons/calendar.png", height: 28, color: AppColor.colorIntroBG),
        Image.asset(
          "assets/icons/consult1.png",
          height: 50,
          color: AppColor.colorIntroBG,
        ),
        Image.asset(
          "assets/icons/medicine1.png",
          height: 50,
          color: AppColor.colorIntroBG,
        ),
        Image.asset(
          "assets/icons/profile1.png",
          height: 50,
          color: AppColor.colorIntroBG,
        ),
      ],
      color: AppColor.white,
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
  //       _navItem("assets/icons/home.png", "Home"),
  //       _navItem("assets/icons/calendar.png", "Calendar"),
  //       _navItem("assets/icons/consult.png", "Consult"),
  //       _navItem("assets/icons/medicine.png", "Medicine"),
  //       _navItem("assets/icons/profile.png", "Profile"),
  //     ],
  //     inactiveIcons: [
  //       _navItem("assets/icons/home1.png", "Home"),
  //       _navItem("assets/icons/calendar1.png", "Calendar"),
  //       _navItem("assets/icons/consult1.png", "Consult"),
  //       _navItem("assets/icons/medicine1.png", "Medicine"),
  //       _navItem("assets/icons/profile1.png", "Profile"),
  //     ],
  //     color: AppColor.white,
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
  //       Image.asset(assetPath, height: 24, color: AppColor.colorIntroBG),
  //       const SizedBox(height: 2),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 10,
  //           fontWeight: FontWeight.w500,
  //           color: AppColor.colorIntroBG,
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
