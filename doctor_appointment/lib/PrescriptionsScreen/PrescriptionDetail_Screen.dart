import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final String doctor;
  final String specialty;
  final String date;
  final List<String> medicines;

  const PrescriptionDetailScreen({
    super.key,
    required this.doctor,
    required this.specialty,
    required this.date,
    required this.medicines,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text("Prescription Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // ✅ allows scrolling
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Doctor Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: const AssetImage(AppImages.d2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      // ✅ prevents overflow in small width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Medicines Section
                const Text(
                  "Medicines Prescribed:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                ...medicines.map(
                  (med) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.medical_services,
                          size: 18,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            med,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Download Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Downloading prescription..."),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("Download PDF"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
