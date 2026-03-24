import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/AppointmentScreen/Appointment_Screen.dart';
import 'package:doctor_appointment/ConsultScreen/Consult_Screen.dart';
import 'package:doctor_appointment/HomeScreen/ConsultPsychiatristScreen/ConsultPsychiatrist_Screen.dart';
import 'package:doctor_appointment/screen/DashBoard/widget/dashboard_widget.dart';
import 'package:doctor_appointment/HomeScreen/OrderMedicineScreen/MedicineCart_Screen.dart';
import 'package:doctor_appointment/LoginScreen/Login_Screen.dart';
import 'package:doctor_appointment/LoginScreen/NewLogin_Screen.dart';
import 'package:doctor_appointment/PrescriptionsScreen/medicalStore_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/screen/profile_screen/UserProfile_Screen.dart';
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

    tabIndex = widget.tabIndex;
    pageController = PageController(initialPage: tabIndex);
  }

  AppBar getAppBar() {
    switch (tabIndex) {
      case 0:
        return AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorPrimary,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.logo, height: 40),
              const SizedBox(width: 6),
              Text(
                "Serenest",
                style: TextStyle(
                  color: AppColor.colorPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.notifications_none,
                color: AppColor.colorPrimary,
                size: 26,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage(AppImages.d1)),
              ),
            ),
          ],
        );
      case 1:
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Appointments",
            style: TextStyle(color: AppColor.colorPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorPrimary,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 2:
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Consult",
            style: TextStyle(color: AppColor.colorPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorPrimary,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      case 3:
        // return AppBar(
        //   backgroundColor: AppColor.white,
        //   title: Text("Medical Store",style: TextStyle(color: AppColor.colorPrimary)),
        //   centerTitle: true,
        //   leading: IconButton(
        //     icon: Icon(icons.menu_rounded, size: 29.0, color: AppColor.colorPrimary),
        //     onPressed: () => _advancedDrawerController.showDrawer(),
        //   ),
        // );
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Order Medicines",
            style: TextStyle(color: AppColor.colorPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorPrimary,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),

          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: AppColor.colorPrimary,
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
            style: TextStyle(color: AppColor.colorPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorPrimary,
            ),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        );
      default:
        return AppBar(
          backgroundColor: AppColor.white,
          title: Text(
            "Doctor Appointment",
            style: TextStyle(color: AppColor.colorPrimary),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              size: 29.0,
              color: AppColor.colorPrimary,
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
              image: AssetImage(AppImages.profile),
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
              DashBoardWidget(),
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

              /// 🔹 Collapsible Consult
              ExpansionTile(
                leading: Icon(
                  Icons.medical_services,
                  color: AppColor.colorPrimary,
                ),
                title: Text(
                  "Consult",
                  style: TextStyle(color: AppColor.colorPrimary),
                ),
                initiallyExpanded: false,
                trailing: Icon(
                  _isConsultExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColor.colorPrimary,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isConsultExpanded = expanded;
                  });
                },
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: AppColor.colorPrimary),
                    title: Text(
                      "Psychiatrist",
                      style: TextStyle(color: AppColor.colorPrimary),
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
                      color: AppColor.colorPrimary,
                    ),
                    title: Text(
                      "Psychologist",
                      style: TextStyle(color: AppColor.colorPrimary),
                    ),
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.healing, color: AppColor.colorPrimary),
                    title: Text(
                      "Therapist",
                      style: TextStyle(color: AppColor.colorPrimary),
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
      leading: Icon(icon, color: AppColor.colorPrimary),
      title: Text(title, style: TextStyle(color: AppColor.colorPrimary)),
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
