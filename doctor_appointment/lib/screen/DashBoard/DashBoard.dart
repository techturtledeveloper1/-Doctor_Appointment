import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/AppointmentScreen/Appointment_Screen.dart';
import 'package:doctor_appointment/ConsultScreen/Consult_Screen.dart';
import 'package:doctor_appointment/HomeScreen/ConsultPsychiatristScreen/ConsultPsychiatrist_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_dialog.dart';
import 'package:doctor_appointment/screen/DashBoard/widget/dashboard_widget.dart';
import 'package:doctor_appointment/HomeScreen/OrderMedicineScreen/MedicineCart_Screen.dart';
import 'package:doctor_appointment/LoginScreen/Login_Screen.dart';
import 'package:doctor_appointment/LoginScreen/NewLogin_Screen.dart';
import 'package:doctor_appointment/PrescriptionsScreen/medicalStore_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/screen/profile_screen/PersonalDetailsScreen/PersonalDetails_Screen.dart';
import 'package:doctor_appointment/screen/profile_screen/Settings/Settings_Screen.dart';
import 'package:doctor_appointment/screen/profile_screen/UserProfile_Screen.dart';
import 'package:doctor_appointment/screen/profile_screen/help_support/help_support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    tabIndex = widget.tabIndex.clamp(0, 4);
    pageController = PageController(initialPage: tabIndex);
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString("fullName") ?? "";
      email = prefs.getString("email") ?? "";
      profileImage = prefs.getString("profileImage") ?? "";
    });
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          size: 29.0,
          color: AppColor.colorPrimary,
        ),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Text(
        tabIndex == 0
            ? "Serenest"
            : tabIndex == 1
            ? "Appointments"
            : tabIndex == 2
            ? "Consult"
            : tabIndex == 3
            ? "Order Medicines"
            : "Profile",
        style: TextStyle(color: AppColor.colorPrimary),
      ),
      actions: tabIndex == 0
          ? [
              Icon(Icons.notifications_none, color: AppColor.colorPrimary),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalDetailsScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(AppImages.d3)),
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(),
      drawer: Drawer(child: menuItem()),
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
          DashBoardWidget(),
          AppointmentCalendarScreen(),
          ConsultScreen(
            doctorName: 'Dr. Priya Sharma',
            specialty: 'Cardiologist',
            appointmentTime: DateTime.parse("2025-09-15 10:30:00"),
            hospital: 'Mercy Hospital',
            location: 'Ahmedabad , gujarat',
            image: '',
          ),
          MedicalStoreListScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }

  Widget menuItem1() {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Container(
        color: AppColor.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: profileImage.isEmpty
                      ? const AssetImage(AppImages.d1)
                      : CachedNetworkImage(
                              imageUrl: ApiService.imageurl + profileImage,
                              errorWidget: (context, url, error) =>
                                  Image.asset(AppImages.d1),
                            )
                            as ImageProvider,
                ),
                title: Text(
                  "jay Patel",
                  style: TextStyle(
                    color: AppColor.colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "jaypatel123@Gmail.com",
                  style: TextStyle(color: AppColor.colorPrimary),
                ),
              ),
              Divider(color: AppColor.colorPrimary),
              drawerItem("Home", Icons.home, 0),
              drawerItem("Appointments", Icons.calendar_today, 1),

              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,

                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  collapsedShape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                  ),

                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,

                  leading: Icon(
                    Icons.medical_services,
                    color: AppColor.colorPrimary,
                  ),
                  title: Text(
                    "Consult",
                    style: TextStyle(color: AppColor.colorPrimary),
                  ),

                  children: [
                    ListTile(title: Text("Psychiatrist"), onTap: () {}),
                    ListTile(title: Text("Psychologist"), onTap: () {}),
                  ],
                ),
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
      ),
    );
  }

  Widget menuItem() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.colorPrimary,
                AppColor.colorPrimary.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: profileImage.isEmpty
                    ? const AssetImage(AppImages.d1)
                    : NetworkImage(ApiService.imageurl + profileImage)
                          as ImageProvider,
              ),
              const SizedBox(height: 10),
              Text(
                username.isEmpty ? "Jay Patel" : username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                email.isEmpty ? "jaypatel123@gmail.com" : email,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              // ✅ Index based navigation
              buildLightItem(Icons.home, "Home", 0),
              buildLightItem(Icons.calendar_today, "Appointments", 1),

              ExpansionTile(
                leading: Icon(
                  Icons.medical_services,
                  color: AppColor.colorPrimary,
                ),
                title: const Text("Consult"),
                children: [
                  subItem("Psychiatrist", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsultPsychiatristScreen(
                          specializationId: '',
                        ),
                      ),
                    );
                  }),
                  subItem("Psychologist", () {}),
                  subItem("Therapist", () {}),
                ],
              ),

              buildLightItem(Icons.description, "Prescriptions", 3),
              buildLightItem(Icons.person, "Profile", 4),

              // ✅ ONLY HERE Navigator
              buildLightItem(
                Icons.settings,
                "Settings",
                0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsScreen()),
                  );
                },
              ),

              // ✅ ONLY HERE Navigator
              buildLightItem(
                Icons.help_outline,
                "Help & Support",
                0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HelpSupportScreen()),
                  );
                },
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () async {
                  showLogoutDialog(context);
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColor.colorPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLightItem(
    IconData icon,
    String title,
    int index, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.pop(context);

        if (onTap != null) {
          onTap(); // Only Settings & Help
        } else {
          setState(() {
            tabIndex = index;
            pageController.jumpToPage(index);
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColor.colorPrimary, size: 22),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget subItem(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget drawerItem(
    String title,
    IconData icon,
    int index, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColor.colorPrimary),
      title: Text(title, style: TextStyle(color: AppColor.colorPrimary)),
      onTap: () {
        Navigator.pop(context);
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
      circleColor: AppColor.colorPrimary,
      activeIcons: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(
            AppImages.home_svg,
            height: 20,
            width: 20,
            color: AppColor.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(
            AppImages.calendar_svg,
            height: 20,
            width: 20,
            color: AppColor.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(
            AppImages.support_svg,
            height: 20,
            width: 20,
            color: AppColor.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(
            AppImages.medicine_svg,
            height: 20,
            width: 20,
            color: AppColor.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(
            AppImages.profile_svg,
            height: 20,
            width: 20,
            color: AppColor.white,
          ),
        ),
      ],
      inactiveIcons: [
        SvgPicture.asset(
          AppImages.home_svg,
          height: 24,
          width: 24,
          color: AppColor.colorPrimary,
        ),
        SvgPicture.asset(
          AppImages.calendar_svg,
          height: 24,
          width: 24,
          color: AppColor.colorPrimary,
        ),
        SvgPicture.asset(
          AppImages.support_svg,
          height: 24,
          width: 24,
          color: AppColor.colorPrimary,
        ),
        SvgPicture.asset(
          AppImages.medicine_svg,
          height: 24,
          width: 24,
          color: AppColor.colorPrimary,
        ),
        SvgPicture.asset(
          AppImages.profile_svg,
          height: 24,
          width: 24,
          color: AppColor.colorPrimary,
        ),
      ],
      color: AppColor.colorPrimary.withAlpha((255 * 0.2).round()),
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

  Future<void> callLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
    );
  }
}
