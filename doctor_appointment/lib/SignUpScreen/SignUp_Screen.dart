import 'dart:convert';
import 'package:doctor_appointment/DashBoard/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ResetPassword/Otp_Screen.dart';
import '../Utils/ColorConstant.dart';
import '../../APIService/ApiService.dart'; // ✅ for API call

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  /// ✅ Signup API Integration
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    Map<String, dynamic> signupData = {
      "fullName": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": int.tryParse(_phoneController.text.trim()) ?? 0,
      "password": _passwordController.text.trim(),
    };

    try {
      var response = await ApiService().callSignupApi(signupData);
      setState(() => isLoading = false);

      if (response != null && response["success"] == true) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Signup successful!")),
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userToken", response["token"]);
        await prefs.setString("userName", response["user"]["fullName"]);
        await prefs.setString("userEmail", response["user"]["email"]);

        print("✅ Token Saved: ${response["token"]}");

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashBoardNew(0, false, false),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?["message"] ?? "Signup failed")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/Images/logo.png",
                    height: 250,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Sign up with your details",
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),

                const SizedBox(height: 20),

                Text(
                  "Create Profile",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.colorIntroBG,
                  ),
                ),

                const SizedBox(height: 30),

                // --- Full Name ---
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? "Enter full name" : null,
                ),
                const SizedBox(height: 16),

                // --- Email ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter email";
                    } else if (!value.contains("@")) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- Phone ---
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter phone number";
                    } else if (value.length != 10) {
                      return "Enter valid 10-digit phone";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- Password ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter password"
                      : (value.length < 6
                      ? "Password must be at least 6 characters"
                      : null),
                ),

                const SizedBox(height: 30),

                // --- Continue Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: ColorConstant.colorIntroBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: isLoading ? null : _handleSignup,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Continue",
                      style:
                      TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
