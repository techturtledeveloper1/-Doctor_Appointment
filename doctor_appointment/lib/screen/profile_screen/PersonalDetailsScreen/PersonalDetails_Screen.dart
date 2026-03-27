import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditPersonaDetailsl_Screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  bool _isLoading = true;

  // Controllers
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _genderCtrl = TextEditingController();
  final TextEditingController _bloodCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _medicalIssueCtrl = TextEditingController();

  bool hasMedicalHistory = false;
  int? age;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileFromAPI();
  }

  Future<void> _loadProfileFromAPI() async {
    setState(() => _isLoading = true);

    try {
      var res = await ApiService().callGetProfileApi();

      if (res != null && res["success"] == true) {
        var data = res["data"]?[0] ?? res["user"];

        if (data != null) {
          _setData(data);
        }
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() => _isLoading = false);
  }

  void _setData(dynamic data) {
    List<String> name = (data["fullName"] ?? "").split(" ");

    _firstNameCtrl.text = name.isNotEmpty ? name.first : "";
    _lastNameCtrl.text = name.length > 1 ? name.sublist(1).join(" ") : "";

    _phoneCtrl.text =
        data["phone"]?.toString() ??
        data["userDetails"]?["phone"]?.toString() ??
        "";

    _emailCtrl.text =
        data["email"]?.toString() ??
        data["userDetails"]?["email"]?.toString() ??
        "";

    if (data["dateOfBirth"] != null) {
      DateTime dob = DateTime.parse(data["dateOfBirth"]);
      _dobCtrl.text = "${dob.day}/${dob.month}/${dob.year}";
      age = DateTime.now().year - dob.year;
    }

    _genderCtrl.text = _capitalize(data["gender"]);
    _bloodCtrl.text = data["bloodGroup"] ?? "";
    _heightCtrl.text = data["height"] != null ? "${data["height"]} cm" : "";
    _weightCtrl.text = data["weight"] != null ? "${data["weight"]} kg" : "";

    profileImageUrl = data["profile_photo"];

    if (data["medical_history"]?["history"] == "yes") {
      hasMedicalHistory = true;
      _medicalIssueCtrl.text = data["medical_history"]["issue"] ?? "";
    }
  }

  String _capitalize(String? str) {
    if (str == null || str.isEmpty) return "";
    return str[0].toUpperCase() + str.substring(1);
  }

  Widget infoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColor.colorPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : "Not available",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.white, size: 25),
        backgroundColor: AppColor.colorPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Profile Header
                  Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColor.grey.withAlpha(
                              (255 * 0.2).round(),
                            ),
                            backgroundImage:
                                profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty
                                ? NetworkImage(profileImageUrl!)
                                : AssetImage(AppImages.profile),
                            child: profileImageUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColor.grey.withAlpha(
                                      (255 * 0.8).round(),
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColor.grey.withAlpha(
                                      (255 * 0.8).round(),
                                    ),
                                  ),
                          ),

                          /// 🔥 EDIT ICON
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                      firstName: _firstNameCtrl.text,
                                      lastName: _lastNameCtrl.text,
                                      phone: _phoneCtrl.text,
                                      email: _emailCtrl.text,
                                      dob: _dobCtrl.text,
                                      gender: _genderCtrl.text ?? "",
                                      bloodGroup: _bloodCtrl.text ?? "",
                                      height: _heightCtrl.text ?? "",
                                      weight: _weightCtrl.text ?? "",
                                      hasMedicalHistory: hasMedicalHistory,
                                      medicalIssue: _medicalIssueCtrl.text,
                                      profileImage: profileImageUrl ?? "",
                                    ),
                                  ),
                                ).then((_) {
                                  // Reload profile data when returning from edit screen
                                  _loadProfileFromAPI();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColor.colorPrimary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        "${_firstNameCtrl.text} ${_lastNameCtrl.text}",

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _emailCtrl.text.isNotEmpty
                            ? _emailCtrl.text
                            : "No Email",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Personal Info
                  sectionTitle("Personal Information"),
                  infoTile("Phone", _phoneCtrl.text, Icons.phone),
                  infoTile(
                    "Date of Birth",
                    _dobCtrl.text,
                    Icons.calendar_today,
                  ),
                  if (age != null) infoTile("Age", "$age years", Icons.cake),

                  /// Health Info
                  sectionTitle("Health Details"),
                  infoTile("Gender", _genderCtrl.text, Icons.person),
                  infoTile("Blood Group", _bloodCtrl.text, Icons.bloodtype),
                  infoTile("Height", _heightCtrl.text, Icons.height),
                  infoTile("Weight", _weightCtrl.text, Icons.monitor_weight),

                  /// Medical
                  sectionTitle("Medical"),
                  infoTile(
                    "Medical History",
                    hasMedicalHistory ? "Yes" : "No",
                    Icons.medical_services,
                  ),

                  if (hasMedicalHistory)
                    infoTile(
                      "Medical Issue",
                      _medicalIssueCtrl.text,
                      Icons.warning,
                    ),
                ],
              ),
            ),
    );
  }
}
