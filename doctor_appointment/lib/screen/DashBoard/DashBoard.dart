import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/AppointmentScreen/Appointment_Screen.dart';
import 'package:doctor_appointment/ConsultScreen/Consult_Screen.dart';
import 'package:doctor_appointment/HomeScreen/ConsultPsychiatristScreen/ConsultPsychiatrist_Screen.dart';
import 'package:doctor_appointment/Notification/notification_listener.dart';
import 'package:doctor_appointment/Notification/notification_services.dart';
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
  int drawerIndex = 0;

  late PageController pageController;
  bool _isConsultExpanded = false;

  @override
  void initState() {
    super.initState();

    SystemChannels.textInput.invokeMethod('TextInput.hide');

    tabIndex = widget.tabIndex.clamp(0, 3);
    drawerIndex = tabIndex;
    pageController = PageController(initialPage: tabIndex);
    loadUserData();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await NotificationService().init();

    // Start listening to appointments
    // Get doctor ID from SharedPreferences or Auth service
    final prefs = await SharedPreferences.getInstance();
    final doctorId = prefs.getString('doctorId') ?? 'doctor_1';

    // AppointmentNotificationListener().startListening(doctorId, context);
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString("fullName") ?? "";
      email = prefs.getString("email") ?? "";
      profileImage = prefs.getString("profileImage") ?? "";
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    // AppointmentNotificationListener().stopListening();
    super.dispose();
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
            drawerIndex = v;
          });
        },
        children: [
          DashBoardWidget(),
          AppointmentCalendarScreen(),
          // ConsultScreen(
          //   doctorName: 'Dr. Priya Sharma',
          //   specialty: 'Cardiologist',
          //   appointmentTime: DateTime.parse("2025-09-15 10:30:00"),
          //   hospital: 'Mercy Hospital',
          //   location: 'Ahmedabad , gujarat',
          //   image: '',
          //   appointmentId: '',
          //   patientId: '',
          // ),
          MedicalStoreListScreen(),
          ProfileScreen(),
        ],
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
                username.isEmpty ? "User Name" : username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                email.isEmpty ? "example@gmail.com" : email,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              buildLightItem(Icons.home, "Home", 0),
              buildLightItem(Icons.calendar_today, "Appointments", 1),

              Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),

                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 10),
                  childrenPadding: EdgeInsets.zero,
                  shape: LinearBorder.none,
                  collapsedShape: LinearBorder.none,
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
                    subItem("Psychologist", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConsultPsychiatristScreen(
                            specializationId: '',
                          ),
                        ),
                      );
                    }),
                    subItem("Therapist", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConsultPsychiatristScreen(
                            specializationId: '',
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              buildLightItem(Icons.description, "Prescriptions", 3),
              buildLightItem(Icons.person, "Profile", 4),

              buildLightItem(
                Icons.settings,
                "Settings",
                100,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsScreen()),
                  );
                  setState(() => drawerIndex = 100);
                },
              ),

              buildLightItem(
                Icons.help_outline,
                "Help & Support",
                101,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HelpSupportScreen()),
                  );
                  setState(() => drawerIndex = 101);
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
    bool isSelected = tabIndex == index;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);

        if (onTap != null) {
          onTap();
        } else {
          setState(() {
            tabIndex = index;
            drawerIndex = index;

            pageController.jumpToPage(index);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.colorPrimary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColor.colorPrimary, size: 22),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? AppColor.colorPrimary : AppColor.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget subItem(String title, VoidCallback onTap) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.only(left: 50, top: 0, bottom: 0),
      title: Text(title, style: TextStyle(fontSize: 14, color: AppColor.black)),

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
        // Padding(
        //   padding: const EdgeInsets.all(15),
        //   child: SvgPicture.asset(
        //     AppImages.support_svg,
        //     height: 20,
        //     width: 20,
        //     color: AppColor.white,
        //   ),
        // ),
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
        // SvgPicture.asset(
        //   AppImages.support_svg,
        //   height: 24,
        //   width: 24,
        //   color: AppColor.colorPrimary,
        // ),
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
          drawerIndex = index;
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
