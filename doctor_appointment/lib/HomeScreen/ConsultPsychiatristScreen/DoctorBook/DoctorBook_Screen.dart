import 'dart:convert';
import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/screen/DashBoard/DashBoard.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
  late Razorpay _razorpay;
  static const String razorpayKey = "rzp_test_YourKeyHere";
  @override
  void initState() {
    super.initState();
    selectedConsultType = widget.selectedConsultType;
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openRazorpay() {
    int amount = _getAmount();

    var options = {
      'key': razorpayKey,
      'amount': amount * 100,
      'name': 'Doctor Appointment',
      'description': selectedConsultType,
      'prefill': {'contact': '9999999999', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm'],
      },
      'theme': {'color': '#195C65'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  int _getAmount() {
    switch (selectedConsultType) {
      case "chat":
        return widget.doctor["chatFee"] ?? 150;
      case "audio":
        return widget.doctor["audioFee"] ?? 300;
      case "video":
        return widget.doctor["videoFee"] ?? 600;
      default:
        return 0;
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("✅ Payment Success: ${response.paymentId}");
    if (response.paymentId != null) {
      await _confirmBookingAfterPayment(response.paymentId!);
    } else {
      print("❌ Payment ID is null");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment verification failed")),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("❌ Payment Failed: ${response.message}");
    Fluttertoast.showToast(
      msg: 'Payment Failed',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColor.errorIconColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar(
      "Wallet",
      "${'External Wallet'}: ${response.walletName}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.colorPrimary,
    );
  }

  Future<void> _confirmBookingAfterPayment(String paymentId) async {
    setState(() => isLoading = true);

    try {
      String formattedDate = _formatDateToYMD(widget.selectedDate);

      Map<String, dynamic> body = {
        "doctorId": widget.doctor["_id"],
        "clinicAddressId":
            widget.doctor["clinicAddressId"] ?? "68bad62466b24b65c0ac9180",
        "appointmentDate": formattedDate,
        "appointmentTime": widget.selectedTime,
        "reason": "Regular health checkup",
        "payment_type": "online",
        "payment_method": "razorpay",
        "transaction_id": paymentId,
        "mode": selectedConsultType,
        "slotId": widget.slotId,
        "amount": _getAmount(),
      };

      var response = await ApiService().callBookAppointmentApi(body);

      if (response != null && response["success"] == true) {
        _showPaymentSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?["message"] ?? "Booking failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    } finally {
      setState(() => isLoading = false);
    }
  }

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
            AppButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => DashBoardNew(
                //       1,
                //       false,
                //       false,
                //       "",
                //       null,
                //       null,
                //       null,
                //       null,
                //       null,
                //       0,
                //       null,
                //       "",
                //       null,
                //       {
                //         "doctor": widget.doctor["name"],
                //         "specialty":
                //             widget.doctor["speciality"] ??
                //             widget.doctor["specialty"],
                //         "time": widget.selectedTime,
                //         "status": "Confirmed",
                //         "type": selectedConsultType ?? "Video",
                //         "image": widget.doctor["image"],
                //         "date": widget.selectedDate,
                //       },
                //     ),
                //   ),
                // );
              },
              text: "OK",
              textStyle: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
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
      backgroundColor: AppColor.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.white),
        elevation: 0,
        backgroundColor: AppColor.colorPrimary,
        centerTitle: true,

        title: Text(
          "Book Appointment",
          style: TextStyle(fontSize: 20, color: AppColor.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
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
                            color: AppColor.colorPrimary,
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

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColor.colorPrimary,
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
                        color: AppColor.colorPrimary,
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

            Text(
              "Select Consultation Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ["chat", "audio", "video"].map((type) {
                final isSelected = selectedConsultType == type;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedConsultType = type);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.colorPrimary
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.colorPrimary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getIcon(type),
                          size: 18,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${type.toUpperCase()}  ₹${consultFees[type]}",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 10),
            ...paymentMethods.map((method) {
              return RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: method,
                groupValue: selectedPayment,
                activeColor: AppColor.colorPrimary,
                title: Text(method),
                onChanged: (value) {
                  setState(() => selectedPayment = value);
                },
              );
            }).toList(),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed:
                    (selectedPayment == null ||
                        selectedConsultType == null ||
                        isLoading)
                    ? null
                    // : _openRazorpay,
                    : _confirmAndPay,
                isLoading: isLoading,
                text: "Confirm & Pay ₹${consultFees[selectedConsultType!]}",
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcon(String type) {
    switch (type) {
      case "chat":
        return Icons.chat_outlined;
      case "audio":
        return Icons.call_outlined;
      case "video":
        return Icons.videocam_outlined;
      default:
        return Icons.help_outline;
    }
  }

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
}
