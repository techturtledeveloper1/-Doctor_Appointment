import 'package:doctor_appointment/DashBoard/DashBoard.dart';
import 'package:doctor_appointment/HomeScreen/Home_screen.dart';
import 'package:doctor_appointment/HomeScreen/NewHome_screen.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment/Utils/AppColor.dart';

import 'TrackOrder_Screen.dart';

class OrderConfirmedScreen extends StatelessWidget {
  final String prescriptionId;
  final int itemCount;
  final String deliveryAddress;
  final double totalAmount;

  const OrderConfirmedScreen({
    super.key,
    required this.prescriptionId,
    required this.itemCount,
    required this.deliveryAddress,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text("Order Confirm",style: TextStyle(color: AppColor.colorIntroBG)),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.colorIntroBG,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Check Icon
                  Icon(Icons.check_circle, color: AppColor.colorIntroBG, size: 80),
        
                  const SizedBox(height: 16),
        
                  // ✅ Title
                  Text(
                    "Order Confirmed",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.colorIntroBG),
                  ),
        
                  const SizedBox(height: 20),
        
                  // ✅ Delivery scooter image (add your own asset if needed)
                  Image.asset(
                    "assets/images/order.png", // <-- put your scooter image here
                    height: 120,
                  ),
        
                  const SizedBox(height: 20),
        
                  // ✅ Order Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailRow("Prescription ID", prescriptionId,
                            highlight: true),
                        const SizedBox(height: 8),
                        _detailRow("Items", "$itemCount"),
                        const SizedBox(height: 8),
                        _detailRow("Delivery Address", deliveryAddress,
                            highlight: true),
                        const Divider(height: 20, thickness: 1),
                        _detailRow("Total", "₹${totalAmount.toStringAsFixed(2)}",
                            highlight: true),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  // ✅ Info Text
                  const Text(
                    "Your order has been confirmed and will be delivered soon.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
        
                  const SizedBox(height: 30),
        
                  // ✅ Track Order Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to Track Order screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrackOrderScreen(
                            prescriptionId: "709325647",
                            orderDate: "April 4, 2024",
                            totalAmount: 375,
                            courierPartner: "ABC Logistics",
                            trackingId: "ABCD123456",
                            trackingSteps: [
                              {
                                "icon": "verified",
                                "title": "Verified",
                                "subtitle": "April 4, 12:30 PM",
                                "status": "true"
                              },
                              {
                                "icon": "packed",
                                "title": "Packed",
                                "subtitle": "April 5, 9:00 AM",
                                "status": "true"
                              },
                              {
                                "icon": "delivery",
                                "title": "Out for Delivery",
                                "subtitle": "April 5, 2:45 PM",
                                "status": "true"
                              },
                              {
                                "icon": "delivered",
                                "title": "Delivered",
                                "subtitle": "",
                                "status": "false"
                              },
                            ],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.colorIntroBG,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Track Order",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
        
                  const SizedBox(height: 12),
        
                  // ✅ Go to Home Button (Outlined)
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DashBoardNew(0,false,false),
                        ),
                      );
                      // Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: AppColor.colorIntroBG),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Go to Home",
                        style: TextStyle(color: AppColor.colorIntroBG, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method for displaying details
  Widget _detailRow(String title, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: highlight ? AppColor.colorIntroBG : Colors.black87,
          ),
        ),
      ],
    );
  }
}
