import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';
import 'MedicineOrderConfirm_Screen.dart';

class MedicineConfirmPaymentScreen extends StatelessWidget {
  final String prescriptionId;
  final List<Map<String, dynamic>> medicines;
  final String deliveryAddress;
  final double totalAmount;

  const MedicineConfirmPaymentScreen({
    super.key,
    required this.prescriptionId,
    required this.medicines,
    required this.deliveryAddress,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text("Payment", style: TextStyle(color: AppColor.colorPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColor.colorPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            Text(
              "Address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.colorPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          deliveryAddress,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Edit",
                      style: TextStyle(color: AppColor.colorPrimary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Payment Method
            Text(
              "Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColor.colorPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  const Text(
                    "VISA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("•••• 1234"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Change",
                      style: TextStyle(color: AppColor.colorPrimary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Center Illustration (Delivery Icon)
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColor.colorPrimary,
                    child: Icon(
                      Icons.local_shipping,
                      size: 50,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total: ₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.colorPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmedScreen(
                        prescriptionId: prescriptionId,
                        itemCount: medicines.length,
                        deliveryAddress: deliveryAddress,
                        totalAmount: totalAmount,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Place Order",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Order Confirmed Screen
