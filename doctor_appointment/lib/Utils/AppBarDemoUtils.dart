import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:doctor_appointment/SignUpScreen/SignUp_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../APIService/ApiService.dart';

import '../../Utils/ColorConstant.dart';
import '../../main.dart';


class AppbarDemoutils extends StatefulWidget {
  @override
  State<AppbarDemoutils> createState() => _AppbarDemoutils();
}

class _AppbarDemoutils extends State<AppbarDemoutils>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int tabIndex = 0;

  late TabController tabController =
  TabController(length: 4, vsync: this, initialIndex: tabIndex);
  String title = "", profileImage = "";
  bool picselected = false;
  String? userId;
  int accountType=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPrefes();

    setState(() {
      if (tabIndex == 0) {
        title = "Home";
      } else if (tabIndex == 1) {
        title = "Worksheet";
      } else if (tabIndex == 2) {
        title = "Leave";
      } else {
        title = "More";
      }
    });
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Profile()),
    // );
    //
    // if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('$result')));

    getPrefes();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        backgroundColor: ColorConstant.colorIntroBG,
        elevation: 0.0,
        title: const Text('Title'),
        shape: const CustomAppBarShape(multi: 0.10),
      ),
      body: SignupScreen(),
    );
  }

  Widget bottomNav() {
    return CircleNavBar(
      activeIcons: [
        Icon(Icons.home, color: ColorConstant.colorWhite, size: 26),
        Icon(Icons.edit_note_sharp, color: ColorConstant.colorWhite, size: 30),
        Icon(Icons.time_to_leave_sharp,
            color: ColorConstant.colorWhite, size: 26),
        Icon(Icons.horizontal_split_sharp,
            size: 26, color: ColorConstant.colorWhite),
      ],
      inactiveIcons: [
        // Text("My"),
        // Text("Home"),
        // Text("Like"),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined,
                color: ColorConstant.colorWhite, size: 24),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.edit_note_outlined,
                color: ColorConstant.colorWhite, size: 24
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.time_to_leave_outlined,
              color: ColorConstant.colorWhite,
              size: 24,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.horizontal_split_outlined,
                size: 24, color: ColorConstant.colorWhite
            ),
          ],
        ),
      ],
      color: ColorConstant.colorIntroBG,
      height: 60,
      circleWidth: 60,

      // tabCurve: ,

      cornerRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
        // bottomRight: Radius.circular(24),
        // bottomLeft: Radius.circular(24),
      ),
      shadowColor: Colors.white,
      elevation: 0, activeIndex: 0,
    );
  }

  Future<void> getPrefes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("getPrefes");

    // setState(() {
    //   profileImage = prefs.getString("profileImage").toString();
    //   print("Profileimage " +
    //       ApiService.image_url_for_experience +
    //       profileImage.toString());
    // });
  }

  void changeTab(int index) {
    setState(() {
      tabIndex = index;
      //_currentPage = _pages[index];
      tabController.animateTo(0);
    });
  }
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double innerCircleRadius = 150.0;

    Path path = Path();
    path.lineTo(0, rect.height);
    path.quadraticBezierTo(rect.width / 2 - (innerCircleRadius / 2) - 30,
        rect.height + 15, rect.width / 2 - 75, rect.height + 50);
    path.cubicTo(
        rect.width / 2 - 40,
        rect.height + innerCircleRadius - 40,
        rect.width / 2 + 40,
        rect.height + innerCircleRadius - 40,
        rect.width / 2 + 75,
        rect.height + 50);
    path.quadraticBezierTo(rect.width / 2 + (innerCircleRadius / 2) + 30,
        rect.height + 15, rect.width, rect.height);
    path.lineTo(rect.width, 0.0);
    path.close();

    return path;
  }
}

class CustomAppBarShape extends ContinuousRectangleBorder {
  final double multi;

  const CustomAppBarShape({this.multi = 0.1});

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double height = rect.height;
    double width = rect.width;
    var path = Path();
    path.lineTo(0, height + width * multi);
    path.arcToPoint(
      Offset(width * multi, height),
      radius: Radius.circular(width * multi),
    );
    path.lineTo(width * (1 - multi), height);
    path.arcToPoint(
      Offset(width, height + width * multi),
      radius: Radius.circular(width * multi),
    );
    path.lineTo(width, 0);
    path.close();

    return path;
  }
}
