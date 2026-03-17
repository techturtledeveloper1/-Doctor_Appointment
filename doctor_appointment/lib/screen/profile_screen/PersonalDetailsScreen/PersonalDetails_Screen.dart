import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../APIService/ApiService.dart';
import '../../../Utils/AppColor.dart';
import 'EditPersonaDetailsl_Screen.dart'; // ✅ Import your edit screen

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _medicalIssueCtrl = TextEditingController();

  String? _gender;
  String? _bloodGroup;
  String? _height;
  String? _weight;
  bool _hasMedicalHistory = false;
  int? _age;
  String? _profileImageUrl;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileFromAPI();
  }

  Future<void> _loadProfileFromAPI() async {
    setState(() => _isLoading = true);

    try {
      var response = await ApiService().callGetProfileApi();

      if (response != null && response["success"] == true) {
        _processProfileData(response);
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?["message"] ?? "Failed to load profile"),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("❌ Profile API Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading profile: $e")));
    }
  }

  void _processProfileData(dynamic res) {
    try {
      print("📥 Processing profile data: ${json.encode(res)}");

      var data;

      // Handle different response structures
      if (res["data"] != null &&
          res["data"] is List &&
          res["data"].isNotEmpty) {
        // Original structure from getProfile API
        data = res["data"][0];
        _processOriginalStructure(data);
      } else if (res["user"] != null) {
        // Updated structure from editProfile API
        data = res["user"];
        _processUpdatedStructure(data);
      } else {
        print("⚠️ Unknown data structure");
        return;
      }
    } catch (e) {
      print("⚠️ Profile data parse error: $e");
    }

    setState(() => _isLoading = false);
  }

  void _processOriginalStructure(dynamic data) {
    print("🔄 Processing original structure");

    List<String> nameParts = data["fullName"].split(" ");
    _firstNameCtrl.text = nameParts.isNotEmpty ? nameParts[0] : "";
    _lastNameCtrl.text = nameParts.length > 1
        ? nameParts.sublist(1).join(" ")
        : "";

    _phoneCtrl.text = data["userDetails"]["phone"].toString();
    _emailCtrl.text = data["userDetails"]["email"].toString();

    if (data["dateOfBirth"] != null) {
      DateTime dob = DateTime.parse(data["dateOfBirth"]);
      _dobCtrl.text = "${dob.day}/${dob.month}/${dob.year}";
      _age = int.tryParse(data["age"].toString()) ?? _calculateAge(dob);
    }

    _gender = _capitalize(data["gender"]);
    _bloodGroup = data["bloodGroup"]?.toString();
    _height = data["height"] != null ? "${data["height"]} cm" : null;
    _weight = data["weight"] != null ? "${data["weight"]} kg" : null;
    _profileImageUrl = data["profile_photo"];

    if (data["medical_history"] != null &&
        data["medical_history"]["history"] == "yes") {
      _hasMedicalHistory = true;
      _medicalIssueCtrl.text = data["medical_history"]["issue"] ?? "";
    } else {
      _hasMedicalHistory = false;
      _medicalIssueCtrl.text = "";
    }
  }

  void _processUpdatedStructure(dynamic data) {
    print("🔄 Processing updated structure");

    List<String> nameParts = data["fullName"].split(" ");
    _firstNameCtrl.text = nameParts.isNotEmpty ? nameParts[0] : "";
    _lastNameCtrl.text = nameParts.length > 1
        ? nameParts.sublist(1).join(" ")
        : "";

    _phoneCtrl.text = data["phone"].toString();
    _emailCtrl.text = data["email"].toString();

    if (data["dateOfBirth"] != null) {
      DateTime dob = DateTime.parse(data["dateOfBirth"]);
      _dobCtrl.text = "${dob.day}/${dob.month}/${dob.year}";
      _age = int.tryParse(data["age"].toString()) ?? _calculateAge(dob);
    }

    _gender = _capitalize(data["gender"]);
    _bloodGroup = data["bloodGroup"]?.toString();
    _height = data["height"] != null ? "${data["height"]} cm" : null;
    _weight = data["weight"] != null ? "${data["weight"]} kg" : null;
    _profileImageUrl = data["profile_photo"];

    if (data["medical_history"] != null &&
        data["medical_history"]["history"] == "yes") {
      _hasMedicalHistory = true;
      _medicalIssueCtrl.text = data["medical_history"]["issue"] ?? "";
    } else {
      _hasMedicalHistory = false;
      _medicalIssueCtrl.text = "";
    }
  }

  String _capitalize(String? str) {
    if (str == null || str.isEmpty) return "";
    return str[0].toUpperCase() + str.substring(1);
  }

  int _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return max(age, 0);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColor.textColor2),
      filled: true,
      fillColor: AppColor.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.deviderColour2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.deviderColour2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.colorIntroBG, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Personal Details",
          style: TextStyle(color: AppColor.colorIntroBG),
        ),
        backgroundColor: AppColor.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColor.colorIntroBG),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    firstName: _firstNameCtrl.text,
                    lastName: _lastNameCtrl.text,
                    phone: _phoneCtrl.text,
                    email: _emailCtrl.text,
                    dob: _dobCtrl.text,
                    gender: _gender ?? "",
                    bloodGroup: _bloodGroup ?? "",
                    height: _height ?? "",
                    weight: _weight ?? "",
                    hasMedicalHistory: _hasMedicalHistory,
                    medicalIssue: _medicalIssueCtrl.text,
                    profileImage: _profileImageUrl ?? "",
                  ),
                ),
              ).then((_) {
                // Reload profile data when returning from edit screen
                _loadProfileFromAPI();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Image
                  Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColor.deviderColour2,
                      backgroundImage:
                          _profileImageUrl != null &&
                              _profileImageUrl!.isNotEmpty
                          ? NetworkImage(_profileImageUrl!)
                          : null,
                      child:
                          _profileImageUrl == null || _profileImageUrl!.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: AppColor.colorIntroBG,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Read-only fields
                  TextFormField(
                    controller: _firstNameCtrl,
                    readOnly: true,
                    decoration: _inputDecoration("First Name"),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _lastNameCtrl,
                    readOnly: true,
                    decoration: _inputDecoration("Last Name"),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _phoneCtrl,
                    readOnly: true,
                    decoration: _inputDecoration("Phone Number"),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _emailCtrl,
                    readOnly: true,
                    decoration: _inputDecoration("Email"),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _dobCtrl,
                    readOnly: true,
                    decoration: _inputDecoration("Date of Birth"),
                  ),
                  if (_age != null) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Age: $_age years",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.colorIntroBG,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      "Gender",
                    ).copyWith(hintText: _gender ?? "Not specified"),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      "Blood Group",
                    ).copyWith(hintText: _bloodGroup ?? "Not specified"),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      "Height",
                    ).copyWith(hintText: _height ?? "Not specified"),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      "Weight",
                    ).copyWith(hintText: _weight ?? "Not specified"),
                  ),
                  const SizedBox(height: 15),

                  // Medical History
                  TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      "Medical History",
                    ).copyWith(hintText: _hasMedicalHistory ? "Yes" : "No"),
                  ),

                  if (_hasMedicalHistory &&
                      _medicalIssueCtrl.text.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _medicalIssueCtrl,
                      readOnly: true,
                      maxLines: 3,
                      decoration: _inputDecoration("Medical Issue"),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
