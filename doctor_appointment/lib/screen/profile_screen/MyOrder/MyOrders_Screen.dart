import 'package:flutter/material.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        backgroundColor: AppColor.colorPrimary,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 3, // dummy count
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.local_shipping, color: AppColor.colorIntroBG),
              title: Text("Order #${1001 + index}"),
              subtitle: Text("Status: Delivered"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: () {
                // Navigate to order details
              },
            ),
          );
        },
      ),
    );
  }
}
