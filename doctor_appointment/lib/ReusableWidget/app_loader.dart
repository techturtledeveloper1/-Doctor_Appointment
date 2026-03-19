import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class AppLoader extends StatelessWidget {
  Color? loaderColor;
  double size;
  double strokeWidth;
  double padding;

  AppLoader({
    this.padding = 14,
    this.size = 10,
    this.strokeWidth = 2,
    this.loaderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    loaderColor ??= AppColor.white;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          color: loaderColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
