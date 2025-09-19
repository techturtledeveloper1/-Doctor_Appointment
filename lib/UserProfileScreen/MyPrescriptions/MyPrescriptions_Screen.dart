import 'package:flutter/material.dart';
import '../../Utils/ColorConstant.dart';

class MyPrescriptionsScreen extends StatelessWidget {
  const MyPrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        title: Text("My Prescriptions", style: TextStyle(color: ColorConstant.colorIntroBG)),
        backgroundColor: ColorConstant.colorWhite,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5, // dummy list count
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.description, color: ColorConstant.colorIntroBG),
              title: Text("Prescription #${index + 1}"),
              subtitle: Text("Doctor: Dr. John Doe"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Navigate to prescription details
              },
            ),
          );
        },
      ),
    );
  }
}
