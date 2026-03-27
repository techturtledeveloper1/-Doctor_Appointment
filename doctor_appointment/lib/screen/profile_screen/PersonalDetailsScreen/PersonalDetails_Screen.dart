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
                            backgroundColor: AppColor.grey50,
                            backgroundImage:
                                profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty
                                ? NetworkImage(profileImageUrl!)
                                : AssetImage(AppImages.profile),
                            child: profileImageUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColor.black,
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColor.black,
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

// class PersonalDetailsScreen extends StatefulWidget {
//   const PersonalDetailsScreen({super.key});
//
//   @override
//   State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
// }
//
// class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Controllers
//   final TextEditingController _firstNameCtrl = TextEditingController();
//   final TextEditingController _lastNameCtrl = TextEditingController();
//   final TextEditingController _phoneCtrl = TextEditingController();
//   final TextEditingController _emailCtrl = TextEditingController();
//   final TextEditingController _dobCtrl = TextEditingController();
//   final TextEditingController _medicalIssueCtrl = TextEditingController();
//
//   String? _gender;
//   String? _bloodGroup;
//   String? _height;
//   String? _weight;
//   bool _hasMedicalHistory = false;
//   int? _age;
//   String? _profileImageUrl;
//
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfileFromAPI();
//   }
//
//   Future<void> _loadProfileFromAPI() async {
//     setState(() => _isLoading = true);
//
//     try {
//       var response = await ApiService().callGetProfileApi();
//
//       if (response != null && response["success"] == true) {
//         _processProfileData(response);
//       } else {
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(response?["message"] ?? "Failed to load profile"),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       print("❌ Profile API Error: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error loading profile: $e")));
//     }
//   }
//
//   void _processProfileData(dynamic res) {
//     try {
//       print("📥 Processing profile data: ${json.encode(res)}");
//
//       var data;
//
//       // Handle different response structures
//       if (res["data"] != null &&
//           res["data"] is List &&
//           res["data"].isNotEmpty) {
//         // Original structure from getProfile API
//         data = res["data"][0];
//         _processOriginalStructure(data);
//       } else if (res["user"] != null) {
//         // Updated structure from editProfile API
//         data = res["user"];
//         _processUpdatedStructure(data);
//       } else {
//         print("⚠️ Unknown data structure");
//         return;
//       }
//     } catch (e) {
//       print("⚠️ Profile data parse error: $e");
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   void _processOriginalStructure(dynamic data) {
//     print("🔄 Processing original structure");
//
//     List<String> nameParts = data["fullName"].split(" ");
//     _firstNameCtrl.text = nameParts.isNotEmpty ? nameParts[0] : "";
//     _lastNameCtrl.text = nameParts.length > 1
//         ? nameParts.sublist(1).join(" ")
//         : "";
//
//     _phoneCtrl.text = data["userDetails"]["phone"].toString();
//     _emailCtrl.text = data["userDetails"]["email"].toString();
//
//     if (data["dateOfBirth"] != null) {
//       DateTime dob = DateTime.parse(data["dateOfBirth"]);
//       _dobCtrl.text = "${dob.day}/${dob.month}/${dob.year}";
//       _age = int.tryParse(data["age"].toString()) ?? _calculateAge(dob);
//     }
//
//     _gender = _capitalize(data["gender"]);
//     _bloodGroup = data["bloodGroup"]?.toString();
//     _height = data["height"] != null ? "${data["height"]} cm" : null;
//     _weight = data["weight"] != null ? "${data["weight"]} kg" : null;
//     _profileImageUrl = data["profile_photo"];
//
//     if (data["medical_history"] != null &&
//         data["medical_history"]["history"] == "yes") {
//       _hasMedicalHistory = true;
//       _medicalIssueCtrl.text = data["medical_history"]["issue"] ?? "";
//     } else {
//       _hasMedicalHistory = false;
//       _medicalIssueCtrl.text = "";
//     }
//   }
//
//   void _processUpdatedStructure(dynamic data) {
//     print("🔄 Processing updated structure");
//
//     List<String> nameParts = data["fullName"].split(" ");
//     _firstNameCtrl.text = nameParts.isNotEmpty ? nameParts[0] : "";
//     _lastNameCtrl.text = nameParts.length > 1
//         ? nameParts.sublist(1).join(" ")
//         : "";
//
//     _phoneCtrl.text = data["phone"].toString();
//     _emailCtrl.text = data["email"].toString();
//
//     if (data["dateOfBirth"] != null) {
//       DateTime dob = DateTime.parse(data["dateOfBirth"]);
//       _dobCtrl.text = "${dob.day}/${dob.month}/${dob.year}";
//       _age = int.tryParse(data["age"].toString()) ?? _calculateAge(dob);
//     }
//
//     _gender = _capitalize(data["gender"]);
//     _bloodGroup = data["bloodGroup"]?.toString();
//     _height = data["height"] != null ? "${data["height"]} cm" : null;
//     _weight = data["weight"] != null ? "${data["weight"]} kg" : null;
//     _profileImageUrl = data["profile_photo"];
//
//     if (data["medical_history"] != null &&
//         data["medical_history"]["history"] == "yes") {
//       _hasMedicalHistory = true;
//       _medicalIssueCtrl.text = data["medical_history"]["issue"] ?? "";
//     } else {
//       _hasMedicalHistory = false;
//       _medicalIssueCtrl.text = "";
//     }
//   }
//
//   String _capitalize(String? str) {
//     if (str == null || str.isEmpty) return "";
//     return str[0].toUpperCase() + str.substring(1);
//   }
//
//   int _calculateAge(DateTime dob) {
//     DateTime today = DateTime.now();
//     int age = today.year - dob.year;
//     if (today.month < dob.month ||
//         (today.month == dob.month && today.day < dob.day)) {
//       age--;
//     }
//     return max(age, 0);
//   }
//
//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: AppColor.textColor2),
//       filled: true,
//       fillColor: AppColor.white,
//       contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColor.deviderColour2),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColor.deviderColour2),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: AppColor.colorIntroBG, width: 2),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       appBar: AppBar(
//         backgroundColor: AppColor.colorPrimary,
//         title: Text(
//           "Personal Details",
//           style: TextStyle(color: AppColor.colorPrimary, fontSize: 20),
//         ),
//         iconTheme: IconThemeData(color: AppColor.white, size: 25),
//
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit, color: AppColor.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditProfileScreen(
//                     firstName: _firstNameCtrl.text,
//                     lastName: _lastNameCtrl.text,
//                     phone: _phoneCtrl.text,
//                     email: _emailCtrl.text,
//                     dob: _dobCtrl.text,
//                     gender: _gender ?? "",
//                     bloodGroup: _bloodGroup ?? "",
//                     height: _height ?? "",
//                     weight: _weight ?? "",
//                     hasMedicalHistory: _hasMedicalHistory,
//                     medicalIssue: _medicalIssueCtrl.text,
//                     profileImage: _profileImageUrl ?? "",
//                   ),
//                 ),
//               ).then((_) {
//                 // Reload profile data when returning from edit screen
//                 _loadProfileFromAPI();
//               });
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   // Profile Image
//                   Center(
//                     child: CircleAvatar(
//                       radius: 55,
//                       backgroundColor: AppColor.deviderColour2,
//                       backgroundImage:
//                           _profileImageUrl != null &&
//                               _profileImageUrl!.isNotEmpty
//                           ? NetworkImage(_profileImageUrl!)
//                           : null,
//                       child:
//                           _profileImageUrl == null || _profileImageUrl!.isEmpty
//                           ? Icon(
//                               Icons.person,
//                               size: 60,
//                               color: AppColor.colorIntroBG,
//                             )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//
//                   // Read-only fields
//                   TextFormField(
//                     controller: _firstNameCtrl,
//                     readOnly: true,
//                     decoration: _inputDecoration("First Name"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   TextFormField(
//                     controller: _lastNameCtrl,
//                     readOnly: true,
//                     decoration: _inputDecoration("Last Name"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   TextFormField(
//                     controller: _phoneCtrl,
//                     readOnly: true,
//                     decoration: _inputDecoration("Phone Number"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   TextFormField(
//                     controller: _emailCtrl,
//                     readOnly: true,
//                     decoration: _inputDecoration("Email"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   TextFormField(
//                     controller: _dobCtrl,
//                     readOnly: true,
//                     decoration: _inputDecoration("Date of Birth"),
//                   ),
//                   if (_age != null) ...[
//                     const SizedBox(height: 10),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Age: $_age years",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: AppColor.colorIntroBG,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 20),
//
//                   TextFormField(
//                     readOnly: true,
//                     decoration: _inputDecoration(
//                       "Gender",
//                     ).copyWith(hintText: _gender ?? "Not specified"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   TextFormField(
//                     readOnly: true,
//                     decoration: _inputDecoration(
//                       "Blood Group",
//                     ).copyWith(hintText: _bloodGroup ?? "Not specified"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   TextFormField(
//                     readOnly: true,
//                     decoration: _inputDecoration(
//                       "Height",
//                     ).copyWith(hintText: _height ?? "Not specified"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   TextFormField(
//                     readOnly: true,
//                     decoration: _inputDecoration(
//                       "Weight",
//                     ).copyWith(hintText: _weight ?? "Not specified"),
//                   ),
//                   const SizedBox(height: 15),
//
//                   // Medical History
//                   TextFormField(
//                     readOnly: true,
//                     decoration: _inputDecoration(
//                       "Medical History",
//                     ).copyWith(hintText: _hasMedicalHistory ? "Yes" : "No"),
//                   ),
//
//                   if (_hasMedicalHistory &&
//                       _medicalIssueCtrl.text.isNotEmpty) ...[
//                     const SizedBox(height: 15),
//                     TextFormField(
//                       controller: _medicalIssueCtrl,
//                       readOnly: true,
//                       maxLines: 3,
//                       decoration: _inputDecoration("Medical Issue"),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//     );
//   }
// }
