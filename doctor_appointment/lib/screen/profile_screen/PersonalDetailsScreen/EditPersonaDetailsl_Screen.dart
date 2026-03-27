import 'dart:math';

import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String height;
  final String weight;
  final bool hasMedicalHistory;
  final String medicalIssue;
  final String profileImage;

  const EditProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.hasMedicalHistory,
    required this.medicalIssue,
    required this.profileImage,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  // Controllers
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _medicalIssueCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  String? _gender;
  String? _bloodGroup;
  bool _hasMedicalHistory = false;
  int? _age;
  File? _selectedImage;
  String? _profileImageUrl;

  // Dropdown lists
  final List<String> _bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-",
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _firstNameCtrl.text = widget.firstName;
    _lastNameCtrl.text = widget.lastName;
    _phoneCtrl.text = widget.phone;
    _emailCtrl.text = widget.email;
    if (widget.dob.isNotEmpty) {
      try {
        List<String> parts = widget.dob.split('-');
        DateTime dob = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );

        _dobCtrl.text =
            "${dob.day.toString().padLeft(2, '0')}/${dob.month.toString().padLeft(2, '0')}/${dob.year}";

        _age = _calculateAge(dob);
      } catch (e) {
        _dobCtrl.text = widget.dob;
      }
    }

    _gender = widget.gender.isNotEmpty ? widget.gender : null;
    _bloodGroup = widget.bloodGroup.isNotEmpty ? widget.bloodGroup : null;

    // Extract numeric values from height and weight
    if (widget.height.isNotEmpty) {
      String heightValue = widget.height.replaceAll(' cm', '');
      _heightCtrl.text = heightValue;
    }

    if (widget.weight.isNotEmpty) {
      String weightValue = widget.weight.replaceAll(' kg', '');
      _weightCtrl.text = weightValue;
    }

    _hasMedicalHistory = widget.hasMedicalHistory;
    _medicalIssueCtrl.text = widget.medicalIssue;
    _profileImageUrl = widget.profileImage;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickDOB() async {
    DateTime now = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _dobCtrl.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
        _age = _calculateAge(pickedDate);
      });
    }
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

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Get token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString("token");
        String formattedDob = "";
        if (_dobCtrl.text.isNotEmpty) {
          List<String> parts = _dobCtrl.text.split('/');
          DateTime dob = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );

          formattedDob =
              "${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
        }

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Authentication token not found"),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        // Prepare data according to API format from Postman - USE PUT METHOD
        Map<String, dynamic> profileData = {
          "fullName":
              "${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}",
          "gender": _gender?.toLowerCase() ?? "",
          "dateOfBirth": formattedDob,
          "email": _emailCtrl.text.trim(),
          "age": _age?.toString() ?? "",
          "height": _heightCtrl.text.trim(),
          "weight": _weightCtrl.text.trim(),
          "medical_history[history]": _hasMedicalHistory ? "yes" : "no",
          "medical_history[issue]": _hasMedicalHistory
              ? _medicalIssueCtrl.text.trim()
              : "",
        };

        print("📤 Sending profile data: $profileData");

        // Call update profile API with PUT method
        var response = await ApiService().callUpdateProfileApi(
          profileData,
          _selectedImage,
          token,
        );

        print("📥 Update Profile Response: $response");

        if (response != null && response["message"] == "Profile updated") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile updated successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Wait for snackbar to show, then navigate back
          await Future.delayed(Duration(milliseconds: 1500));

          // Navigate back to PersonalDetailsScreen
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response?["message"] ?? "Failed to update profile"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print("❌ Error in _saveProfile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile: $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Edit Personal Details",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        centerTitle: true,

        iconTheme: IconThemeData(color: AppColor.white, size: 25),
        backgroundColor: AppColor.colorPrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: AppColor.deviderColour2,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_profileImageUrl != null &&
                                      _profileImageUrl!.isNotEmpty
                                  ? NetworkImage(_profileImageUrl!)
                                  : null),
                        child:
                            _selectedImage == null &&
                                (_profileImageUrl == null ||
                                    _profileImageUrl!.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: AppColor.colorIntroBG,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColor.colorIntroBG,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // First Name
              AppEditText(
                controller: _firstNameCtrl,
                hint: "Enter your first name",
                label: "First Name",

                validator: (val) =>
                    val!.isEmpty ? "Enter your first name" : null,
                name: '',
              ),
              SizedBox(height: 5),

              // Last Name
              AppEditText(
                controller: _lastNameCtrl,
                name: '',
                hint: "Enter your last name",
                label: "Last Name",
                validator: (val) =>
                    val!.isEmpty ? "Enter your last name" : null,
              ),
              SizedBox(height: 5),

              // Phone
              AppEditText(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                readOnly: true,
                name: '',
                maxLength: 10,
                hint: "Enter your phone number",
                label: "Phone Number",
              ),
              SizedBox(height: 5),

              // Email
              AppEditText(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                name: '',
                hint: "Enter your email address",
                label: "Email Address",
              ),
              SizedBox(height: 5),

              // DOB + Age
              AppEditText(
                controller: _dobCtrl,
                readOnly: true,
                onTap: _pickDOB,
                name: '',
                hint: "Date of Birth (DD-MM-YYYY)",
                label: "Date of Birth",

                suffixIcon: Icon(
                  Icons.calendar_month_rounded,
                  color: AppColor.colorPrimary,
                ),
              ),
              if (_age != null) ...[
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Age: $_age years",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.colorPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 5),

              AppEditText(
                name: '',
                label: "Blood Group",
                hint: "Select Blood Group",
                isDropdown: true,
                dropdownItems: _bloodGroups,
                dropdownValue: _bloodGroup,
                suffixIcon: Icon(Icons.keyboard_arrow_down),
                onDropdownChanged: (val) {
                  setState(() => _bloodGroup = val);
                },
              ),
              SizedBox(height: 5),

              // Height
              AppEditText(
                controller: _heightCtrl,
                keyboardType: TextInputType.number,
                name: '',
                hint: "Enter height (in cm)",
                label: "Height (In cm)",
              ),
              SizedBox(height: 5),

              // Weight
              AppEditText(
                controller: _weightCtrl,
                keyboardType: TextInputType.number,
                name: '',
                label: "Weight (In kg)",
                hint: "Enter weight (in kg)",
              ),
              SizedBox(height: 15),
              _buildGenderSelector(),
              SizedBox(height: 5),

              // Medical History
              SwitchListTile(
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Any Medical History?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                activeColor: AppColor.colorPrimary,
                value: _hasMedicalHistory,
                onChanged: (val) {
                  setState(() => _hasMedicalHistory = val);
                },
              ),
              if (_hasMedicalHistory) ...[
                SizedBox(height: 5),
                AppEditText(
                  controller: _medicalIssueCtrl,
                  name: '',
                  hint: "Medical Issue",
                  minLines: 5,

                  maxLines: 8,
                ),
              ],
              SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _isLoading ? null : _saveProfile,

                  isLoading: _isLoading,
                  text: "Save Details",
                  textStyle: TextStyle(fontSize: 16, color: AppColor.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    List<String> genders = ["Male", "Female", "Other"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          children: genders.map((gender) {
            bool isSelected = _gender == gender;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _gender = gender);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.colorPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.colorPrimary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      gender,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColor.colorPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
