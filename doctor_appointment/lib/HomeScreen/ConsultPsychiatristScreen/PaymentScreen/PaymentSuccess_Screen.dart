import 'package:doctor_appointment/screen/DashBoard/DashBoard.dart';
import 'package:doctor_appointment/screen/DashBoard/widget/dashboard_widget.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String date;
  final String time;
  final String consultationType;
  final String paymentMethod;

  const PaymentSuccessScreen({
    super.key,
    required this.doctor,
    required this.date,
    required this.time,
    required this.consultationType,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Success Icon
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade100,
                child: Icon(Icons.check_circle, size: 80, color: Colors.green),
              ),
              const SizedBox(height: 24),

              // ✅ Success Text
              Text(
                "Payment Successful!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your appointment has been confirmed.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // ✅ Appointment Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(doctor["image"]),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor["name"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColor.colorIntroBG,
                              ),
                            ),
                            Text(
                              doctor["specialty"],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    _buildInfoRow("Date", date),
                    _buildInfoRow("Time", time),
                    _buildInfoRow("Type", consultationType),
                    _buildInfoRow("Payment", paymentMethod),
                  ],
                ),
              ),
              const Spacer(),

              // ✅ Go to Home Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorIntroBG,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to DashBoardNew and show Appointments tab
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashBoardNew(
                          1, // tabIndex = 1 -> Appointment Calendar
                          false,
                          false,
                        ),
                      ),
                      (route) => false, // removes all previous routes
                    );

                    // Optionally, you can pass selected appointment data
                    // to open ConsultScreen automatically if needed
                  },
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
