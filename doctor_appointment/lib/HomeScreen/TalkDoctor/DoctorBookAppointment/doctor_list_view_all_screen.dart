import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/HomeScreen/ConsultPsychiatristScreen/DoctorDetails/DoctorDetails_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';

class DoctorListViewAllScreen extends StatefulWidget {
  const DoctorListViewAllScreen({super.key});

  @override
  State<DoctorListViewAllScreen> createState() =>
      _DoctorListViewAllScreenState();
}

class _DoctorListViewAllScreenState extends State<DoctorListViewAllScreen> {
  List doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getDoctors();
  }

  Future<void> getDoctors() async {
    final res = await ApiService().callDoctorListViewAllApi();

    print("API RESULT: $res");

    if (res != null && res["success"] == true) {
      setState(() {
        doctors = res["data"] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        doctors = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        centerTitle: true,
        title: Text(
          "All Doctors",
          style: TextStyle(
            color: AppColor.colorPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctors.isEmpty
          ? const Center(child: Text("No doctors found"))
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];

                return Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child:
                              doctor["profile_photo"] != null &&
                                  doctor["profile_photo"].toString().isNotEmpty
                              ? Image.network(
                                  doctor["profile_photo"],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME
                            Text(
                              doctor["fullName"] ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// SPECIALIZATION
                            Text(
                              doctor["specialization"] ?? "",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),

                            const SizedBox(height: 8),

                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _feeChip(
                                  "Consult",
                                  getFee(
                                    doctor["consultationFee"],
                                    doctor["consultationFee"],
                                  ),
                                ),
                                _feeChip(
                                  "Video",
                                  getFee(
                                    doctor["videoCallFee"],
                                    doctor["video_fee"],
                                  ),
                                ),
                                _feeChip(
                                  "Voice",
                                  getFee(
                                    doctor["voiceCallFee"],
                                    doctor["voice_fee"],
                                  ),
                                ),
                                _feeChip(
                                  "Chat",
                                  getFee(doctor["chatFee"], doctor["chat_fee"]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        width: 100,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DoctorDetailScreen(doctorId: doctor["_id"]),
                            ),
                          );
                        },
                        text: "Book",
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _feeChip(String title, dynamic value) {
    if (value == null || value.toString().trim().isEmpty || value == "0") {
      return const SizedBox(); // hide
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text("$title: ₹$value", style: const TextStyle(fontSize: 12)),
    );
  }

  String getFee(dynamic value1, dynamic value2) {
    if (value1 != null && value1.toString().trim().isNotEmpty) {
      return value1.toString();
    } else if (value2 != null && value2.toString().trim().isNotEmpty) {
      return value2.toString();
    }
    return "0";
  }
}
