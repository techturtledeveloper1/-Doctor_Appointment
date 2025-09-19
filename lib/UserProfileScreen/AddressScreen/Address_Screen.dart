import 'package:flutter/material.dart';
import '../../Utils/ColorConstant.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        title: Text("My Address",style: TextStyle(color: ColorConstant.colorIntroBG),),
        backgroundColor: ColorConstant.colorWhite,
    leading: IconButton(
        icon: Icon(Icons.arrow_back, color: ColorConstant.colorIntroBG),
        onPressed: () => Navigator.pop(context),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Street Address",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter your address" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter city" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: "State",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter state" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: zipController,
                decoration: InputDecoration(
                  labelText: "Zip Code",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Please enter zip code" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Address Saved Successfully!"),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Save Address",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
