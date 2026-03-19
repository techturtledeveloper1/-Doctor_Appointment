import 'package:doctor_appointment/APIService/ApiService.dart';
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
          style: TextStyle(color: AppColor.colorIntroBG),
        ),
        backgroundColor: AppColor.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.colorIntroBG),
          onPressed: () => Navigator.pop(context),
        ),
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
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Address Name (e.g., Home, Work)",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? "Please enter address name" : null,
            ),
            SizedBox(height: 12),

            // Address Line 1
            TextFormField(
              controller: addressLine1Controller,
              decoration: InputDecoration(
                labelText: "Address Line 1",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? "Please enter address" : null,
            ),
            SizedBox(height: 12),

            // Address Line 2
            TextFormField(
              controller: addressLine2Controller,
              decoration: InputDecoration(
                labelText: "Address Line 2 (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            // City
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? "Please enter city" : null,
            ),
            SizedBox(height: 12),

            // State
            TextFormField(
              controller: stateController,
              decoration: InputDecoration(
                labelText: "State",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? "Please enter state" : null,
            ),
            SizedBox(height: 12),

            // Postal Code
            TextFormField(
              controller: postalCodeController,
              decoration: InputDecoration(
                labelText: "Postal Code",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Please enter postal code" : null,
            ),
            SizedBox(height: 12),

            // Country
            TextFormField(
              controller: countryController,
              decoration: InputDecoration(
                labelText: "Country",
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? "Please enter country" : null,
            ),
            SizedBox(height: 12),

            // Phone
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value!.isEmpty ? "Please enter phone number" : null,
            ),
            SizedBox(height: 12),

            // Landmark
            TextFormField(
              controller: landmarkController,
              decoration: InputDecoration(
                labelText: "Landmark (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.colorIntroBG,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveAddress,
              child: Text(
                isEditing ? "Update Address" : "Save Address",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
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
      "name": nameController.text,
      "addressLine1": addressLine1Controller.text,
      "addressLine2": addressLine2Controller.text,
      "city": cityController.text,
      "state": stateController.text,
      "postalCode": postalCodeController.text,
      "country": countryController.text,
      "phone": phoneController.text,
      "isDefault": true,
      "landmark": landmarkController.text,
      "location": {
        "type": "Point",
        "coordinates": [72.8777, 19.0760]
      }
    };

    try {
      if (isEditing) {
        // ✅ CORRECTED: Pass the body with updated data
        var response = await ApiService().callUpdateAddressApi(
            widget.address!['_id'],
            body, // ✅ Send the complete updated data
            token
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
        backgroundColor: message.toLowerCase().contains("success") ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
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