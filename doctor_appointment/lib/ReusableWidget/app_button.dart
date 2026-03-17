import 'package:doctor_app/Utils/app_loader.dart';
import 'package:doctor_app/Utils/app_color.dart';
import 'package:doctor_appointment/Utils/app_color.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton({
    this.text = "",
    this.textStyle,
    this.width = double.infinity,
    this.height = 45,
    required this.onPressed,
    this.progressColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.isLoading = false,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.allCaps = false,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.shape,
    this.iconPosition = IconPosition.right,
    super.key,
  });

  double height;
  double width;
  double fontSize;
  String text = "";
  void Function()? onPressed;

  bool isLoading;
  bool allCaps;
  dynamic shape;
  Color? iconColor;

  IconData? icon;
  double? iconSize;
  TextStyle? textStyle;
  FontWeight? fontWeight;
  Color? progressColor;
  Color? backgroundColor;
  Color? disabledBackgroundColor;
  IconPosition? iconPosition;

  @override
  Widget build(BuildContext context) {
    checkCommonStyle();

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width, height),
          padding: EdgeInsets.symmetric(horizontal: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: AppColor.white,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          elevation: 0,
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          if (isLoading) return;
          onPressed?.call();
        },
        child: Stack(
          children: [
            Opacity(opacity: isLoading ? 0 : 1, child: _buildRow()),
            if (isLoading)
              Center(
                child: AppLoader(
                  padding: 0,
                  size: 20,
                  loaderColor: AppColor.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null && iconPosition == IconPosition.left) _buildIcon(),
          SizedBox(
            width: 5,
          ),
          _buildText(),
          if (icon != null && iconPosition == IconPosition.right) _buildIcon(),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Text(
      text,
      style: textStyle,
    );
  }

  Widget _buildIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: iconSize ?? 20, color: iconColor ?? AppColor.white),
      ],
    );
  }

  void checkCommonStyle() {
    textStyle ??= TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: AppColor.white,
    );
    progressColor ??= AppColor.white;
    backgroundColor ??= AppColor.colorIntroBG;
    disabledBackgroundColor ??= AppColor.colorIntroBG;
  }
}

enum IconPosition { left, right }
