import 'package:flutter/material.dart';
import '../../Utils/ColorConstant.dart';
import 'dart:math';

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

  // Dropdown lists
  final List<String> _bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];

  final List<String> _heights =
  List.generate(61, (i) => "${140 + i} cm"); // 140–200 cm
  final List<String> _weights =
  List.generate(101, (i) => "${40 + i} kg"); // 40–140 kg

  Future<void> _pickDOB() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _dobCtrl.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
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

  InputDecoration _inputDecoration(String label, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: ColorConstant.textColor2),
      filled: true,
      fillColor: ColorConstant.colorWhite,
      suffixIcon: suffix,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorConstant.deviderColour2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorConstant.deviderColour2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorConstant.colorIntroBG, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite, // light background
      appBar: AppBar(
        title: Text("Personal Details",style: TextStyle(color: ColorConstant.colorIntroBG),),
        backgroundColor: ColorConstant.colorWhite,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: ColorConstant.deviderColour2,
                      child: Icon(Icons.person,
                          size: 60, color: ColorConstant.colorIntroBG),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: ColorConstant.colorIntroBG,
                        child: Icon(Icons.edit, color: Colors.white, size: 18),
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
                validator: (val) =>
                val!.isEmpty ? "Enter your first name" : null,
              ),
              SizedBox(height: 15),

              // Last Name
              TextFormField(
                controller: _lastNameCtrl,
                decoration: _inputDecoration("Last Name"),
                validator: (val) =>
                val!.isEmpty ? "Enter your last name" : null,
              ),
              SizedBox(height: 15),

              // Phone
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
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
                  "Date of Birth",
                  suffix: Icon(Icons.calendar_today,
                      color: ColorConstant.colorIntroBG),
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
                        color: ColorConstant.colorIntroBG,
                        fontWeight: FontWeight.w500),
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
              DropdownButtonFormField<String>(
                value: _height,
                items: _heights
                    .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                    .toList(),
                onChanged: (val) => setState(() => _height = val),
                decoration: _inputDecoration("Height"),
              ),
              SizedBox(height: 15),

              // Weight
              DropdownButtonFormField<String>(
                value: _weight,
                items: _weights
                    .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                    .toList(),
                onChanged: (val) => setState(() => _weight = val),
                decoration: _inputDecoration("Weight"),
              ),
              SizedBox(height: 15),

              // Medical History
              SwitchListTile(
                title: Text(
                  "Any Medical History?",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                activeColor: ColorConstant.colorIntroBG,
                value: _hasMedicalHistory,
                onChanged: (val) {
                  setState(() => _hasMedicalHistory = val);
                },
              ),
              if (_hasMedicalHistory) ...[
                TextFormField(
                  controller: _medicalIssueCtrl,
                  decoration: _inputDecoration("Medical Issue"),
                ),
              ],
              SizedBox(height: 25),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Details Saved Successfully")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.colorIntroBG,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child:
                  Text("Save Details", style: TextStyle(fontSize: 16,color: ColorConstant.colorWhite)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
