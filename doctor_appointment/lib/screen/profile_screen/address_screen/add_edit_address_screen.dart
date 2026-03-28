import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? address;
  final Function() onAddressSaved;

  const AddEditAddressScreen({
    Key? key,
    this.address,
    required this.onAddressSaved,
  }) : super(key: key);

  @override
  _AddEditAddressScreenState createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedType = "Home"; // default
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  bool isLoading = false;
  bool get isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _populateForm();
    }
  }

  void _populateForm() {
    final address = widget.address!;

    fullNameController.text = address['fullName'] ?? '';
    selectedType = address['name'] ?? "Home"; // ✅ FIXED
    nameController.text = address['name'] ?? '';

    addressLine1Controller.text = address['addressLine1'] ?? '';
    addressLine2Controller.text = address['addressLine2'] ?? '';
    cityController.text = address['city'] ?? '';
    stateController.text = address['state'] ?? '';
    postalCodeController.text = address['postalCode'] ?? '';
    countryController.text = address['country'] ?? '';
    phoneController.text = address['phone'] ?? '';
    landmarkController.text = address['landmark'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Address" : "Add New Address",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        backgroundColor: AppColor.colorPrimary,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Address Type (Name)
            AppEditText(
              controller: fullNameController,
              hint: "Full Name",
              name: "",
              validator: (value) =>
                  value!.isEmpty ? "Please enter full name" : null,
            ),
            SizedBox(height: 5),
            // Phone
            AppEditText(
              controller: phoneController,
              hint: "Phone Number",
              maxLength: 10,
              name: "",
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return "Enter phone number";
                if (value.length != 10) return "Enter valid 10-digit number";
                return null;
              },
            ),
            SizedBox(height: 5),
            // Address Line 1
            AppEditText(
              controller: addressLine1Controller,
              hint: "Address Line 1",
              name: "",
              validator: (value) =>
                  value!.isEmpty ? "Please enter address" : null,
            ),
            SizedBox(height: 5),

            // Address Line 2
            AppEditText(
              controller: addressLine2Controller,
              hint: "Address Line 2 (Optional)",
              name: "",
            ),
            SizedBox(height: 5),

            // Landmark
            AppEditText(
              controller: landmarkController,
              hint: "Landmark (Optional)",
              name: "",
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: AppEditText(
                    controller: cityController,
                    hint: "City",
                    name: "",
                    validator: (value) =>
                        value!.isEmpty ? "Please enter city" : null,
                  ),
                ),
                SizedBox(width: 15),

                // State
                Expanded(
                  child: AppEditText(
                    controller: stateController,
                    hint: "State",
                    name: "",
                    validator: (value) =>
                        value!.isEmpty ? "Please enter state" : null,
                  ),
                ),
              ],
            ),

            // City
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: AppEditText(
                    controller: postalCodeController,
                    hint: "Postal Code",
                    name: "",
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Enter postal code";
                      if (value.length != 6) return "Enter valid postal code";
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 15),

                // Country
                Expanded(
                  child: AppEditText(
                    controller: countryController,
                    hint: "Country",
                    name: "",
                    validator: (value) =>
                        value!.isEmpty ? "Please enter country" : null,
                  ),
                ),
              ],
            ),

            // Postal Code
            SizedBox(height: 20),

            _buildAddressTypeChips(),
            SizedBox(height: 25),

            // Save Button
            AppButton(
              isLoading: isLoading,
              onPressed: _saveAddress,
              text: isEditing ? "Update Address" : "Save Address",
              textStyle: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeChips() {
    List<String> types = ["Home", "Work", "Other"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: types.map((type) {
        bool isSelected = selectedType == type;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedType = type;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.colorIntroBG : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColor.colorIntroBG
                      : Colors.grey.shade300,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColor.colorIntroBG.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      _showSnackBar("Authentication error");
      setState(() {
        isLoading = false;
      });
      return;
    }

    Map<String, dynamic> body = {
      "fullName": fullNameController.text,
      "addressLine1": addressLine1Controller.text,
      "addressLine2": addressLine2Controller.text,
      "city": cityController.text,
      "state": stateController.text,
      "postalCode": postalCodeController.text,
      "country": countryController.text,
      "phone": phoneController.text,
      "isDefault": true,
      "name": selectedType,
      "landmark": landmarkController.text,
      "location": {
        "type": "Point",
        "coordinates": [72.8777, 19.0760],
      },
    };

    try {
      if (isEditing) {
        // ✅ CORRECTED: Pass the body with updated data
        var response = await ApiService().callUpdateAddressApi(
          widget.address!['_id'],
          body, // ✅ Send the complete updated data
          token,
        );

        if (response['success'] == true) {
          _showSnackBar("Address updated successfully!");
          widget.onAddressSaved();
          Navigator.pop(context);
        } else {
          _showSnackBar(response['message'] ?? "Failed to update address");
        }
      } else {
        // Add new address
        var response = await ApiService().callAddAddressApi(body);

        if (response != null && response['success'] == true) {
          _showSnackBar("Address added successfully!");
          widget.onAddressSaved();
          Navigator.pop(context);
        } else {
          _showSnackBar("Failed to add address");
        }
      }
    } catch (e) {
      _showSnackBar("An error occurred: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.toLowerCase().contains("success")
            ? Colors.green
            : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    phoneController.dispose();
    landmarkController.dispose();
    super.dispose();
  }
}
