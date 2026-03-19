import 'package:flutter/material.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';

class TrackOrderScreen extends StatelessWidget {
  final String prescriptionId;
  final String orderDate;
  final double totalAmount;
  final List<Map<String, String>> trackingSteps;
  final String courierPartner;
  final String trackingId;

  const TrackOrderScreen({
    super.key,
    required this.prescriptionId,
    required this.orderDate,
    required this.totalAmount,
    required this.trackingSteps,
    required this.courierPartner,
    required this.trackingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Track Order",
          style: TextStyle(color: AppColor.colorPrimary),
        ),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.colorIntroBG,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Order Summary Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Prescription ID",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        prescriptionId,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.colorIntroBG,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Order Date",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        orderDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Right
                  Text(
                    "₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Tracking Timeline
            Column(
              children: trackingSteps.map((step) {
                bool isCompleted = step["status"] == "true";
                return _trackingStep(
                  icon: step["icon"]!,
                  title: step["title"]!,
                  subtitle: step["subtitle"]!,
                  completed: isCompleted,
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // ✅ Courier Info
            Text(
              "Courier Partner: $courierPartner",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              "Tracking ID: $trackingId",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 30),

            // ✅ Button
            ElevatedButton(
              onPressed: () {
                // Example: Navigate to courier tracking page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.colorIntroBG,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Track with Courier",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Tracking Step Widget
  Widget _trackingStep({
    required String icon,
    required String title,
    required String subtitle,
    required bool completed,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline + Icon
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? AppColor.colorIntroBG : Colors.grey.shade300,
              ),
              child: Icon(_getIcon(icon), size: 18, color: Colors.white),
            ),
            Container(width: 2, height: 50, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),

        // Texts
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: completed ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: completed ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ✅ Map icon name to actual icon
  IconData _getIcon(String name) {
    switch (name) {
      case "verified":
        return Icons.check_circle;
      case "packed":
        return Icons.inventory_2;
      case "delivery":
        return Icons.local_shipping;
      case "delivered":
        return Icons.home_filled;
      default:
        return Icons.circle;
    }
  }
}
