import 'package:flutter/material.dart';
import '../../Utils/ColorConstant.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        title: Text("Payments", style: TextStyle(color: ColorConstant.colorIntroBG)),
        backgroundColor: ColorConstant.colorWhite,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet, color: ColorConstant.colorIntroBG),
              title: Text("Wallet Balance"),
              subtitle: Text("₹ 1500.00"),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Add Payment Method")),
              );
            },
            icon: Icon(Icons.add_card,color: ColorConstant.colorWhite,),
            label: Text("Add Payment Method",style: TextStyle(color: ColorConstant.colorWhite),),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.colorIntroBG,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    );
  }
}
