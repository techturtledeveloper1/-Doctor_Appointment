import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../APIService/ApiService.dart';
import '../../Utils/ColorConstant.dart';
import 'DoctorDetails/DoctorDetails_Screen.dart';

class ConsultPsychiatristScreen extends StatefulWidget {
  final String specializationId; // pass specializationId from previous screen

  const ConsultPsychiatristScreen({super.key, required this.specializationId});

  @override
  State<ConsultPsychiatristScreen> createState() =>
      _ConsultPsychiatristScreenState();
}

class _ConsultPsychiatristScreenState extends State<ConsultPsychiatristScreen> {
  String selectedLanguage = "English";
  late Future<List<Map<String, dynamic>>> doctorsFuture;

  @override
  void initState() {
    super.initState();
    doctorsFuture = fetchDoctors();
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    ApiService apiService = ApiService();
    var response =
    await apiService.callGetSpecializationList(widget.specializationId);

    if (response != null && response["success"] == true) {
      List data = response["data"];
      return data.map<Map<String, dynamic>>((doc) {
        return {
          "_id": doc["_id"]?.toString() ?? "", // ✅ Added safe ID handling
          "name": doc["fullName"] ?? "",
          "specialty": doc["specialzationName"] ?? "",
          "image": doc["profile_photo"] ?? "assets/Images/d1.png",
          "rating": doc["avgRating"] ?? 0,
          "reviews": doc["totalReview"] ?? 0,
          "chatFee": doc["chatFee"] ?? 0,
          "audioFee": doc["voiceCallFee"] ?? 0,
          "videoFee": doc["videoCallFee"] ?? 0,
          "about": doc["about"] ?? "",
          "languages": doc["languages"] ?? [],
        };
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        backgroundColor: ColorConstant.colorWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Consult",
          style: TextStyle(
            color: ColorConstant.colorIntroBG,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Dropdown
            Row(
              children: [
                const Text("Language : ",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                DropdownButton<String>(
                  value: selectedLanguage,
                  underline: const SizedBox(),
                  items: ["English", "Hindi", "Spanish"].map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedLanguage = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Doctor List
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: doctorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No doctors found"));
                  }

                  final doctors = snapshot.data!;
                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Image
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                doctor["image"].toString().startsWith("http")
                                    ? NetworkImage(doctor["image"])
                                    : AssetImage(doctor["image"])
                                as ImageProvider,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Doctor Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          doctor["name"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          ColorConstant.colorIntroBG,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          final doctorId =
                                              doctor["_id"]?.toString() ?? "";
                                          if (doctorId.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Doctor ID not available"),
                                            ));
                                            return;
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DoctorDetailScreen(
                                                      doctorId: doctorId),
                                            ),
                                          );
                                        },
                                        child: const Text("Consult"),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    doctor["specialty"],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                          Icons.star,
                                          size: 16, color: Colors.teal
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${doctor["rating"]}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "(${doctor["reviews"]})",
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Chat ₹${doctor["chatFee"]} | Audio ₹${doctor["audioFee"]} | Video ₹${doctor["videoFee"]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
