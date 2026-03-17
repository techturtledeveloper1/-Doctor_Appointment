import 'package:flutter/material.dart';
import '../Utils/ColorConstant.dart';
import 'OnlineOrder/onlineOrder_Screen.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prescription",style: TextStyle(color: ColorConstant.colorIntroBG),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 👩‍⚕️ Doctor Image
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/Images/d2.png"),
            ),
            const SizedBox(height: 12),

            /// 📝 Doctor Info
            Text(
              "Dr. Sarah Jones\nPsychiatrist\nJul 10, 2023",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: ColorConstant.colorIntroBG),
            ),

            const SizedBox(height: 20),

            /// Rx Icon
            Text("Rx",
                style: TextStyle(fontSize: 48, color: ColorConstant.colorIntroBG)),

            const SizedBox(height: 20),

            /// Buttons with same width
            SizedBox(
              width: 200, // 👈 set your desired width
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.colorIntroBG,
                      foregroundColor: Colors.white, // 👈 text color
                    ),
                    child: const Text("Download"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.colorIntroBG,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Share"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const onlineOrderMedicineScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.colorIntroBG,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Order Medicines"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
