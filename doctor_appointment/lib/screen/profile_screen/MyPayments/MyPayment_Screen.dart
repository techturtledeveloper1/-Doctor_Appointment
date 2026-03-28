import 'package:flutter/material.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Payments",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        iconTheme: IconThemeData(color: AppColor.white, size: 25),
        centerTitle: true,
        backgroundColor: AppColor.colorPrimary,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),

            child: ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: AppColor.colorIntroBG,
              ),
              title: Text("Wallet Balance"),
              subtitle: Text("₹ 1500.00"),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Add Payment Method")));
            },
            icon: Icon(Icons.add_card, color: AppColor.white),
            label: Text(
              "Add Payment Method",
              style: TextStyle(color: AppColor.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.colorIntroBG,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
