import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//ignore: must_be_immutable
class AppEditText extends StatefulWidget {
  final String? label;
  final String hint;
  final String name;
  final bool readOnly;
  final bool required;
  final bool visible;
  final bool isLoading;
  final int minLines;
  final int maxLines;
  final double suffixIconWidth;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final double topPadding;
  final EdgeInsets? padding;
  final Widget? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? initialValue;
  FocusNode? focusNode;
  FocusNode? nextFocus;
  bool? enable;
  TextCapitalization textCapitalization;
  TextEditingController? controller;

  final bool isRadio;
  final List<Map<String, dynamic>>? radioOptions;
  final int? radioValue;
  final void Function(int?)? onRadioChanged;
  final Color? borderColor;
  bool? isEmail;
  bool? isPassword;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final Function(String?)? onDropdownChanged;

  AppEditText({
    super.key,
    this.label,
    required this.hint,
    required this.name,
    this.required = false,
    this.readOnly = false,
    this.visible = true,
    this.isLoading = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.suffixIconWidth = 0,
    this.maxLength,
    this.onChanged,
    this.onSaved,
    this.enable,
    this.controller,
    this.onTap,
    this.topPadding = 8.0,
    this.padding,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.obscureText = false,
    this.focusNode,
    this.nextFocus,
    this.initialValue,
    this.textCapitalization = TextCapitalization.none,
    this.isRadio = false,
    this.radioOptions,
    this.radioValue,
    this.onRadioChanged,
    this.borderColor,
    this.isEmail = false,
    this.isPassword = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
  });

  @override
  State<AppEditText> createState() => _AppEditTextState();
}

class _AppEditTextState extends State<AppEditText> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();
    return Visibility(
      visible: widget.visible,
      child: Padding(
        padding: EdgeInsets.only(top: widget.topPadding, left: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Row(
                children: [
                  Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  Text(" *", style: TextStyle(color: Colors.red, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 6),
            ],
            widget.isDropdown
                ? DropdownButtonFormField<String>(
                    value: widget.dropdownValue,
                    items: widget.dropdownItems!
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                    onChanged: widget.onDropdownChanged,
                    decoration: myInputDecoration(false),
                  )
                : FormBuilderTextField(
                    name: widget.name,
                    textAlign: TextAlign.start,
                    onTap: widget.onTap,

                    controller: widget.controller,
                    initialValue: widget.initialValue,
                    // enabled: enable,
                    readOnly: widget.readOnly,
                    style: TextStyle(
                      color: AppColor.colorPrimary,
                      fontSize: 14,
                    ),

                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    obscureText: widget.isPassword == true
                        ? _obscure
                        : widget.obscureText,
                    textCapitalization: widget.textCapitalization,
                    decoration: myInputDecoration(_obscure),
                    minLines: widget.minLines,

                    maxLines: widget.maxLines,
                    maxLength: widget.maxLength,

                    validator:
                        widget.validator ??
                        (value) {
                          if (widget.required &&
                              (value == null || value.isEmpty)) {
                            return "${widget.hint} is required";
                          }

                          if (widget.isEmail == true &&
                              value != null &&
                              value.isNotEmpty) {
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );

                            if (!emailRegex.hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                          }

                          return null;
                        },

                    onChanged: widget.onChanged,
                    onSaved: widget.onSaved,
                  ),
          ],
        ),
      ),
    );
  }

  InputDecoration myInputDecoration(bool obscure) {
    return InputDecoration(
      fillColor: AppColor.white,
      counterText: "",

      hintStyle: TextStyle(color: AppColor.colorTextWelcome, fontSize: 14),

      hintText: widget.hint,
      filled: true,
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      prefixStyle: TextStyle(fontSize: 14, color: AppColor.colorPrimary),
      contentPadding: EdgeInsets.all(16),
      prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppColor.grey50),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppColor.grey50),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColor.grey50),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppColor.colorPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColor.errorBorderColor),
      ),
      // suffixIcon: suffixIcon,
      suffixIcon: widget.isPassword == true
          ? GestureDetector(
              child: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: AppColor.borderColourslider,
              ),
              onTap: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
            )
          : widget.suffixIcon,
    );
  }
}
