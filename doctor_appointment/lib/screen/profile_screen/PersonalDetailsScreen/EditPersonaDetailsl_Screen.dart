import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../Utils/AppColor.dart';
import 'dart:math';
import '../../../../APIService/ApiService.dart';

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
    "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"
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

    // Convert date format from DD/MM/YYYY to YYYY-MM-DD
    if (widget.dob.isNotEmpty) {
      try {
        List<String> dobParts = widget.dob.split('/');
        if (dobParts.length == 3) {
          DateTime dob = DateTime(
              int.parse(dobParts[2]),
              int.parse(dobParts[1]),
              int.parse(dobParts[0])
          );
          _dobCtrl.text = "${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
          _age = _calculateAge(dob);
        } else {
          _dobCtrl.text = widget.dob; // Keep as is if not in expected format
        }
      } catch (e) {
        _dobCtrl.text = widget.dob; // Keep original if parsing fails
        print("Error parsing DOB: $e");
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
    DateTime initialDate = now;

    // Set initial date to existing DOB if available
    if (_dobCtrl.text.isNotEmpty) {
      try {
        if (_dobCtrl.text.contains('-')) {
          // Format: YYYY-MM-DD
          List<String> dobParts = _dobCtrl.text.split('-');
          if (dobParts.length == 3) {
            initialDate = DateTime(
                int.parse(dobParts[0]),
                int.parse(dobParts[1]),
                int.parse(dobParts[2])
            );
          }
        } else if (_dobCtrl.text.contains('/')) {
          // Format: DD/MM/YYYY
          List<String> dobParts = _dobCtrl.text.split('/');
          if (dobParts.length == 3) {
            initialDate = DateTime(
                int.parse(dobParts[2]),
                int.parse(dobParts[1]),
                int.parse(dobParts[0])
            );
          }
        }
      } catch (e) {
        print("Error parsing existing DOB: $e");
      }
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        // Format date as YYYY-MM-DD for API
        _dobCtrl.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
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
          "fullName": "${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}",
          "gender": _gender?.toLowerCase() ?? "",
          "dateOfBirth": _dobCtrl.text.trim(),
          "email": _emailCtrl.text.trim(),
          "age": _age?.toString() ?? "",
          "height": _heightCtrl.text.trim(),
          "weight": _weightCtrl.text.trim(),
          "medical_history[history]": _hasMedicalHistory ? "yes" : "no",
          "medical_history[issue]": _hasMedicalHistory ? _medicalIssueCtrl.text.trim() : "",
        };

        print("📤 Sending profile data: $profileData");

        // Call update profile API with PUT method
        var response = await ApiService().callUpdateProfileApi(
            profileData,
            _selectedImage,
            token
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

  InputDecoration _inputDecoration(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColor.textColor2),
      filled: true,
      fillColor: AppColor.white,
      suffixIcon: suffix,
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
          "Edit Personal Details",
          style: TextStyle(color: AppColor.colorIntroBG),
        ),
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image with Edit
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
                            : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                            ? NetworkImage(_profileImageUrl!)
                            : null),
                        child: _selectedImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty)
                            ? Icon(Icons.person, size: 60, color: AppColor.colorIntroBG)
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
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // First Name
              TextFormField(
                controller: _firstNameCtrl,
                decoration: _inputDecoration("First Name"),
                validator: (val) => val!.isEmpty ? "Enter your first name" : null,
              ),
              SizedBox(height: 15),

              // Last Name
              TextFormField(
                controller: _lastNameCtrl,
                decoration: _inputDecoration("Last Name"),
                validator: (val) => val!.isEmpty ? "Enter your last name" : null,
              ),
              SizedBox(height: 15),

              // Phone
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                readOnly: true, // Phone might be non-editable
                decoration: _inputDecoration("Phone Number"),
              ),
              SizedBox(height: 15),

              // Email
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email"),
              ),
              SizedBox(height: 15),

              // DOB + Age
              TextFormField(
                controller: _dobCtrl,
                readOnly: true,
                onTap: _pickDOB,
                decoration: _inputDecoration(
                  "Date of Birth (YYYY-MM-DD)",
                  suffix: Icon(Icons.calendar_today, color: AppColor.colorIntroBG),
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
                      color: AppColor.colorIntroBG,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 20),

              // Gender
              DropdownButtonFormField<String>(
                value: _gender,
                items: ["Male", "Female", "Other"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
                decoration: _inputDecoration("Gender"),
              ),
              SizedBox(height: 15),

              // Blood Group
              DropdownButtonFormField<String>(
                value: _bloodGroup,
                items: _bloodGroups
                    .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                    .toList(),
                onChanged: (val) => setState(() => _bloodGroup = val),
                decoration: _inputDecoration("Blood Group"),
              ),
              SizedBox(height: 15),

              // Height
              TextFormField(
                controller: _heightCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Height (in cm)"),
              ),
              SizedBox(height: 15),

              // Weight
              TextFormField(
                controller: _weightCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Weight (in kg)"),
              ),
              SizedBox(height: 15),

              // Medical History
              SwitchListTile(
                title: Text(
                  "Any Medical History?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                activeColor: AppColor.colorIntroBG,
                value: _hasMedicalHistory,
                onChanged: (val) {
                  setState(() => _hasMedicalHistory = val);
                },
              ),
              if (_hasMedicalHistory) ...[
                SizedBox(height: 15),
                TextFormField(
                  controller: _medicalIssueCtrl,
                  decoration: _inputDecoration("Medical Issue"),
                  maxLines: 3,
                ),
              ],
              SizedBox(height: 25),

              // Save button
              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorIntroBG,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    "Save Details",
                    style: TextStyle(fontSize: 16, color: AppColor.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}