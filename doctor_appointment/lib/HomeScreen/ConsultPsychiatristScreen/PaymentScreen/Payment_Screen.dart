import 'package:flutter/material.dart';
import '../../../Utils/ColorConstant.dart';
import 'PaymentSuccess_Screen.dart';

class PaymentTypeScreen extends StatefulWidget {
  final Map<String, dynamic> doctor; // get doctor info
  final String selectedDate;
  final String selectedTime;
  final String consultationType;

  const PaymentTypeScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.consultationType,
  });

  @override
  State<PaymentTypeScreen> createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends State<PaymentTypeScreen> {
  String? selectedPayment = "UPI"; // default selected

  final List<String> paymentMethods = [
    "UPI",
    "Credit/Debit Card",
    "Net Banking",
    "Wallet",
  ];

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConstant.colorIntroBG),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Select Payment",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorConstant.colorIntroBG,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(doctor["image"]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor["name"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.colorIntroBG,
                          ),
                        ),
                        Text(
                          "${widget.consultationType} • ${widget.selectedDate}, ${widget.selectedTime}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    doctor["fee"] ?? "₹699",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Options
            const Text(
              "Choose Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            ...paymentMethods.map((method) {
              final isSelected = selectedPayment == method;
              return GestureDetector(
                onTap: () => setState(() => selectedPayment = method),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorConstant.colorIntroBG.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? ColorConstant.colorIntroBG
                          : Colors.grey.shade300,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? ColorConstant.colorIntroBG
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        method,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? ColorConstant.colorIntroBG
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentSuccessScreen(
                        doctor: doctor,
                        date: widget.selectedDate,          // ✅ from constructor
                        time: widget.selectedTime,          // ✅ from constructor
                        consultationType: widget.consultationType, // ✅ from constructor
                        paymentMethod: selectedPayment!,    // ✅ non-null
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
