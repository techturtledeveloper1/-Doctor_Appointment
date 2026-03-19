import 'package:doctor_appointment/PrescriptionsScreen/RateScreen/RateSession_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';


class onlineOrderMedicineScreen extends StatelessWidget {
  const onlineOrderMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Medicines",
          style: TextStyle(color: AppColor.colorIntroBG),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Do you want to order these medicines?",
              style: TextStyle(color: AppColor.colorIntroBG),
            ),
            const SizedBox(height: 10),
            Text(
              "• Sertraline 50 mg\n• Aripiprazole 5 mg\n• Clonazepam 0.5 mg",
              textAlign: TextAlign.left,
              style: TextStyle(color: AppColor.colorIntroBG),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RateSessionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.colorIntroBG,
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Proceed to Cart",
                style: TextStyle(color: AppColor.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
