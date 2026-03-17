import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../DashBoard/DashBoard.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String gender = "Male";
  File? _profileImage;

  // Blood groups
  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-"
  ];

  // Heights (4’0" → 7’0")
  final List<String> heights = [
    for (int feet = 4; feet <= 7; feet++)
      for (int inch = 0; inch < 12; inch++) "$feet'${inch}\""
  ];

  // Weight list (30 → 150 KG)
  final List<String> weights = [
    for (int w = 30; w <= 150; w++) "$w"
  ];

  String? selectedBloodGroup;
  String? selectedHeight;
  String? selectedWeight;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
        backgroundColor: const Color(0xFF4285F6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile photo
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt,
                      size: 40, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("First Name"),
            TextField(
              controller: _firstNameController,
              decoration: _inputDecoration("Enter first name"),
            ),
            const SizedBox(height: 15),

            _buildLabel("Last Name"),
            TextField(
              controller: _lastNameController,
              decoration: _inputDecoration("Enter last name"),
            ),
            const SizedBox(height: 15),

            _buildLabel("Mobile Number"),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration("Enter mobile number"),
            ),
            const SizedBox(height: 15),

            _buildLabel("Email"),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration("Enter email"),
            ),
            const SizedBox(height: 15),

            _buildLabel("Address"),
            TextField(
              controller: _addressController,
              decoration: _inputDecoration("Enter address"),
            ),
            const SizedBox(height: 15),

            _buildLabel("Country"),
            TextField(
              controller: _countryController,
              decoration: _inputDecoration("Enter country"),
            ),
            const SizedBox(height: 15),

            _buildLabel("City"),
            TextField(
              controller: _cityController,
              decoration: _inputDecoration("Enter city"),
            ),
            const SizedBox(height: 15),

            // Blood group & Height
            Row(
              children: [
                Expanded(
                    child: _buildDropdown("Blood Group", bloodGroups,
                        selectedBloodGroup, (val) {
                          setState(() => selectedBloodGroup = val);
                        })),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildDropdown(
                        "Height (Feet)", heights, selectedHeight, (val) {
                      setState(() => selectedHeight = val);
                    })),
              ],
            ),
            const SizedBox(height: 15),

            // Weight
            _buildDropdown("Weight (KG)", weights, selectedWeight, (val) {
              setState(() => selectedWeight = val);
            }),
            const SizedBox(height: 15),

            _buildLabel("Gender"),
            Row(
              children: [
                Radio(
                  value: "Male",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                const Text("Male"),
                Radio(
                  value: "Female",
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                const Text("Female"),
              ],
            ),
            const SizedBox(height: 25),

            // Save & Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF4285F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // ✅ Collect values
                  print("First Name: ${_firstNameController.text}");
                  print("Last Name: ${_lastNameController.text}");
                  print("Mobile: ${_mobileController.text}");
                  print("Email: ${_emailController.text}");
                  print("Address: ${_addressController.text}");
                  print("Country: ${_countryController.text}");
                  print("City: ${_cityController.text}");
                  print("Blood Group: $selectedBloodGroup");
                  print("Height: $selectedHeight");
                  print("Weight: $selectedWeight");
                  print("Gender: $gender");
                  print("Profile Photo: $_profileImage");

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DashBoardNew(0, false, false)), // ✅ Dashboard
                  );
                },
                child: const Text(
                  "Save & Continue",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> options, String? value,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      hint: Text(hint, style: const TextStyle(color: Colors.black54)),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
