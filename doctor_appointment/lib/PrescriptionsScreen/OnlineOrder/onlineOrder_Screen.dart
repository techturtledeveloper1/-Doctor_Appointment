import 'package:flutter/material.dart';

import '../../Utils/ColorConstant.dart';
import '../RateScreen/RateSession_Screen.dart';

class onlineOrderMedicineScreen extends StatelessWidget {
  const onlineOrderMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Medicines",style: TextStyle(color : ColorConstant.colorIntroBG),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Do you want to order these medicines?",style: TextStyle(color: ColorConstant.colorIntroBG),),
            const SizedBox(height: 10),
            Text("• Sertraline 50 mg\n• Aripiprazole 5 mg\n• Clonazepam 0.5 mg", textAlign: TextAlign.left,style: TextStyle(color: ColorConstant.colorIntroBG),),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RateSessionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.colorIntroBG,
                foregroundColor: Colors.white,
              ),
              child: Text("Proceed to Cart",style: TextStyle(color: ColorConstant.colorWhite),),
            ),
          ],
        ),
      ),
    );
  }
}
