import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';

import 'ConfirmMedicinePayment_Screen.dart';

class MedicinePaymentScreen extends StatelessWidget {
  final String prescriptionId;
  final List<Map<String, dynamic>> medicines;
  final String deliveryAddress;
  final double totalAmount;

  const MedicinePaymentScreen({
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
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.colorPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ORDER SUMMARY BOX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        "Rx:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(prescriptionId),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...medicines.map((med) {
                    return Text(
                      "${med['name']}  (${med['mg']} mg) - Qty: ${med['quantity']}",
                      style: const TextStyle(fontSize: 14),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Address:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(deliveryAddress)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // PAYMENT OPTIONS
            const Text(
              "Payment Options",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),

            // UPI
            // UPI
            _paymentOption(
              context,
              title: "UPI",
              icons: const [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.blue,
                  size: 22,
                ), // GPay alternative
                Icon(
                  Icons.account_balance,
                  color: Colors.deepPurple,
                  size: 22,
                ), // PhonePe alternative
                Icon(
                  Icons.payment,
                  color: Colors.indigo,
                  size: 22,
                ), // Paytm alternative
              ],
            ),

            // Debit/Credit Card
            _paymentOption(context, title: "Debit/Credit Card", trailing: true),

            // Net Banking
            _paymentOption(context, title: "Net Banking", trailing: true),

            // Cash on Delivery
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Cash on Delivery"),
              trailing: Switch(value: false, onChanged: (val) {}),
            ),

            const SizedBox(height: 24),

            // Pay Now Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicineConfirmPaymentScreen(
                      prescriptionId: prescriptionId,
                      medicines: medicines,
                      deliveryAddress: deliveryAddress,
                      totalAmount: totalAmount,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.colorPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Pay Now", style: TextStyle(color: AppColor.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(
    BuildContext context, {
    required String title,
    List<Widget>? icons,
    bool trailing = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: icons != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: icons
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: e,
                    ),
                  )
                  .toList(),
            )
          : trailing
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : null,
      onTap: () {},
    );
  }
}
