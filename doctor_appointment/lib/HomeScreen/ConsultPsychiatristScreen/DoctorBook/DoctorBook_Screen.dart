import 'dart:convert';
import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/screen/DashBoard/DashBoard.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';

class DoctorBookAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String selectedDate;
  final String selectedTime;
  final String selectedConsultType;
  final String slotId;
  const DoctorBookAppointmentScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedConsultType,
    required this.slotId,
  });

  @override
  State<DoctorBookAppointmentScreen> createState() =>
      _DoctorBookAppointmentScreenState();
}

class _DoctorBookAppointmentScreenState
    extends State<DoctorBookAppointmentScreen> {
  String? selectedConsultType;
  String? selectedPayment;
  bool isLoading = false;

  final List<String> paymentMethods = [
    "UPI",
    "Credit / Debit Card",
    "Net Banking",
    "Wallet",
  ];

  @override
  void initState() {
    super.initState();
    selectedConsultType = widget.selectedConsultType;
  }

  // 🔹 Show Success Dialog
  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Payment Successful",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Your appointment with ${widget.doctor["name"]} has been booked successfully.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashBoardNew(
                      1,
                      false,
                      false,
                      "",
                      null,
                      null,
                      null,
                      null,
                      null,
                      0,
                      null,
                      "",
                      null,
                      {
                        "doctor": widget.doctor["name"],
                        "specialty":
                            widget.doctor["speciality"] ??
                            widget.doctor["specialty"],
                        "time": widget.selectedTime,
                        "status": "Confirmed",
                        "type": selectedConsultType ?? "Video",
                        "image": widget.doctor["image"],
                        "date": widget.selectedDate,
                      },
                    ),
                  ),
                );
              },
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Handle Confirm & Pay API
  // 🔹 Handle Confirm & Pay API
  Future<void> _confirmAndPay() async {
    if (selectedPayment == null || selectedConsultType == null) return;

    setState(() => isLoading = true);

    try {
      // ✅ Convert date from "14/9/2025" ➜ "2025-09-14"
      String formattedDate = _formatDateToYMD(widget.selectedDate);

      // ✅ Get the correct fee based on consultation type
      int amount = 0;
      switch (selectedConsultType) {
        case "chat":
          amount = widget.doctor["chatFee"] ?? 150;
          break;
        case "audio":
          amount = widget.doctor["audioFee"] ?? 300;
          break;
        case "video":
          amount = widget.doctor["videoFee"] ?? 600;
          break;
      }

      Map<String, dynamic> body = {
        "doctorId": widget.doctor["_id"],
        "clinicAddressId":
            widget.doctor["clinicAddressId"] ?? "68bad62466b24b65c0ac9180",
        "appointmentDate": formattedDate,
        "appointmentTime": widget.selectedTime,
        "reason": "Regular health checkup",
        "payment_type": "online",
        "payment_method": selectedPayment,
        "mode": selectedConsultType,
        "slotId": widget.slotId,
        "amount": amount,
      };

      print("📤 Booking Request: $body");
      print("📤 Slot ID being sent: ${widget.slotId}");

      var response = await ApiService().callBookAppointmentApi(body);

      print("📥 Booking Response: $response");

      // ✅ Check for success (both 200 and 201 are success status codes)
      if (response != null && response["success"] == true) {
        print("✅ Appointment booked successfully!");
        _showPaymentSuccessDialog();
      } else {
        print("❌ Booking failed: ${response?["message"]}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?["message"] ?? "Booking failed")),
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _formatDateToYMD(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return "$year-$month-$day";
      }
    } catch (e) {
      print("⚠️ Date parse error: $e");
    }

    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    final Map<String, String> consultFees = {
      "chat": (doctor["chatFee"] ?? 200).toString(),
      "audio": (doctor["audioFee"] ?? 300).toString(),
      "video": (doctor["videoFee"] ?? 600).toString(),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.colorIntroBG),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Book Appointment",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.colorIntroBG,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🩺 Doctor Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        (doctor["image"] != null &&
                            doctor["image"].toString().isNotEmpty)
                        ? NetworkImage(doctor["image"])
                        : const AssetImage("assets/images/default_doctor.png")
                              as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. ${doctor["name"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.colorIntroBG,
                          ),
                        ),
                        Text(
                          doctor["speciality"] ?? doctor["specialty"] ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Slot ID: ${widget.slotId}", // ✅ Fixed: use widget.slotId instead of widget.selectedSlotId
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 📅 Date & Time Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColor.colorIntroBG,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Date: ${widget.selectedDate}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColor.colorIntroBG,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Time: ${widget.selectedTime}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 💬 Select Consultation Type
            const Text(
              "Select Consultation Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: ["chat", "audio", "video"].map((type) {
                final isSelected = selectedConsultType == type;
                return ChoiceChip(
                  label: Text(
                    "${type.toUpperCase()}  ₹${consultFees[type]}",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColor.colorIntroBG,
                  onSelected: (_) {
                    setState(() => selectedConsultType = type);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 💳 Payment Method
            const Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...paymentMethods.map((method) {
              return RadioListTile<String>(
                value: method,
                groupValue: selectedPayment,
                activeColor: AppColor.colorIntroBG,
                title: Text(method),
                onChanged: (value) {
                  setState(() => selectedPayment = value);
                },
              );
            }).toList(),
            const SizedBox(height: 20),

            // ✅ Confirm & Pay Button
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
                onPressed:
                    (selectedPayment == null ||
                        selectedConsultType == null ||
                        isLoading)
                    ? null
                    : _confirmAndPay,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Confirm & Pay ₹${consultFees[selectedConsultType!]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
