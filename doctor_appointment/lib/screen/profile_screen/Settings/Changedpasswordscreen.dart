import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_edit_text.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  // 🔑 Replace this token dynamically from your login/session
  String token = "your_real_bearer_token_here";

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Map<String, dynamic> body = {
      "currentPassword": _currentPasswordController.text.trim(),
      "newPassword": _newPasswordController.text.trim(),
    };

    final response = await callChangedPassword(body, token);
    setState(() => _isLoading = false);

    final isSuccess = response["success"] == true;
    final message =
        response["message"]?.toString() ??
        (isSuccess
            ? "Password changed successfully!"
            : "Failed to change password. Please try again.");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );

    if (isSuccess) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        backgroundColor: AppColor.colorPrimary,
        centerTitle: true,

        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppEditText(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                isPassword: true,

                hint: "Current Password",
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColor.colorIntroBG,
                ),

                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                name: '',
              ),
              const SizedBox(height: 20),
              AppEditText(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                hint: "New Password",
                prefixIcon: Icon(
                  Icons.lock_reset,
                  color: AppColor.colorIntroBG,
                ),

                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter a new password';
                  } else if (val.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                name: '',
                isPassword: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: AppButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  isLoading: _isLoading,
                  text: "Submit",
                  textStyle: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future callChangedPassword(Map<String, dynamic> body, String token) async {}
}
