import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIService/ApiService.dart';
import '../DashBoard/DashBoard.dart';
import '../Utils/ColorConstant.dart';

class LoginWithPasswordScreen extends StatefulWidget {
  const LoginWithPasswordScreen({super.key});

  @override
  State<LoginWithPasswordScreen> createState() =>
      _LoginWithPasswordScreenState();
}

class _LoginWithPasswordScreenState extends State<LoginWithPasswordScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false; // loader flag
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Logo ---
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/Images/logo.png",
                    height: 220,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Login with Phone & Password",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                // --- Mobile Number Input ---
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: "Enter Mobile Number",
                    counterText: "",
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    prefix: const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Text("+91 "),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your mobile number";
                    } else if (value.length < 10) {
                      return "Enter valid 10-digit mobile number";
                    } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                      return "Enter valid Indian mobile number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- Password Input ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // --- Login Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: ColorConstant.colorIntroBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        callLoginApi();
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "Login",
                      style:
                      TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Forgot Password ---
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Forgot Password navigation
                      _showForgotPasswordDialog();
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: ColorConstant.colorIntroBG,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // --- Create Profile ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New here? "),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to Sign Up screen
                        _navigateToSignUp();
                      },
                      child: Text(
                        "Create Profile",
                        style: TextStyle(
                          color: ColorConstant.colorIntroBG,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> callLoginApi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> loginJson = {
        "phone": _mobileController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      ApiService apiService = ApiService();
      var loginRes = await apiService.callLoginApi(loginJson);

      print("Login Response: $loginRes");

      if (loginRes != null && loginRes['token'] != null) {
        // ✅ Save user info
        await prefs.setBool("isLogin", true);
        await prefs.setString("token", loginRes['token']);
        await prefs.setString("userId", loginRes['user']['id'].toString());
        await prefs.setString("fullName", loginRes['user']['fullName'].toString());
        await prefs.setString("email", loginRes['user']['email'].toString());
        await prefs.setString("phone", loginRes['user']['phone'].toString());
        await prefs.setString("role", loginRes['user']['role'].toString());

        // Update global token
        ColorConstant.token = loginRes['token'];

        // ✅ Navigate to dashboard and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoardNew(0, false, false),
          ),
              (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginRes['message'] ?? "Login successful"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // ❌ Invalid credentials or unregistered number
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loginRes?['message'] ?? "Invalid credentials or user not registered",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // ❌ Network or server error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Network error: ${e.toString()}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password?"),
        content: const Text("Please contact support or use OTP login to reset your password."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _navigateToSignUp() {
    // TODO: Replace with your actual sign up screen navigation
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SignUpScreen()),
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Navigate to Sign Up screen"),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Optional: Clear form when screen is disposed
  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}