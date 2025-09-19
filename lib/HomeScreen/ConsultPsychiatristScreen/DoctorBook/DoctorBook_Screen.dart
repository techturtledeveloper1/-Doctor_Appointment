import 'package:flutter/material.dart';
import '../../../Utils/ColorConstant.dart';
import '../PaymentScreen/Payment_Screen.dart';

class DoctorBookAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctor; // 👈 store doctor data
  final String selectedDate;
  final String selectedTime;

  const DoctorBookAppointmentScreen({super.key, required this.doctor,required this.selectedDate,
    required this.selectedTime,});

  @override
  State<DoctorBookAppointmentScreen> createState() =>
      _DoctorBookAppointmentScreenState();
}

class _DoctorBookAppointmentScreenState
    extends State<DoctorBookAppointmentScreen> {
  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;
  String consultationType = "Video";

  // final String selectedDate;
  // final String selectedTime;

  // final List<String> dates = ["Mon 10", "Tue 11", "Wed 12"];
  // final List<String> times = ["10:30 AM", "10:30 AM", "5:30 PM"];

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor; // 👈 access doctor data here

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
          "Book Appointment",
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
            // ✅ Doctor Info Card with dynamic data
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
                    backgroundImage: AssetImage(doctor["image"]), // dynamic image
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor["name"], // dynamic name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.colorIntroBG,
                        ),
                      ),
                      Text(
                        doctor["specialty"], // dynamic specialty
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection
            Row(
              children: [
                Icon(Icons.calendar_today, color: ColorConstant.colorIntroBG),
                const SizedBox(width: 10),
                Text(
                  widget.selectedDate,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ✅ Show Selected Time
            Row(
              children: [
                Icon(Icons.access_time, color: ColorConstant.colorIntroBG),
                const SizedBox(width: 10),
                Text(
                  widget.selectedTime,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Fee + Type
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Fee",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(
                        doctor["fee"] ?? "₹699", // 👈 dynamic fee if available
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Video / Voice toggle
                  Row(
                    children: [
                      _buildTypeButton("Video"),
                      const SizedBox(width: 12),
                      _buildTypeButton("Voice"),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentTypeScreen(
                        doctor: doctor,
                        selectedDate: widget.selectedDate,
                        selectedTime: widget.selectedTime,
                        consultationType: consultationType,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Confirm Appointment",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type) {
    final isSelected = consultationType == type;
    return GestureDetector(
      onTap: () => setState(() => consultationType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstant.colorIntroBG : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? ColorConstant.colorIntroBG
                : Colors.grey.shade400,
          ),
        ),
        child: Text(
          type,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
