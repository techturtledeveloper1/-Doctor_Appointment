import 'package:flutter/material.dart';
import '../../Utils/AppColor.dart';
import 'DoctorDetails_Screen.dart';

class DoctorListScreen extends StatelessWidget {
  final String speciality;
  final List<String> selectedSymptoms;

  const DoctorListScreen({
    super.key,
    required this.speciality,
    required this.selectedSymptoms,
  });

  // Dummy Doctor Data
  final List<Map<String, dynamic>> doctors = const [
    {
      "name": "Dr. Anjali Mehta",
      "speciality": "Gynecologist",
      "experience": "12 years",
      "online": true,
      "desc": "Specialist in women’s health and gynecology treatments.",
      "image": "assets/images/d6.png",
    },
    {
      "name": "Dr. Kavita Patel",
      "speciality": "Gynecologist",
      "experience": "7 years",
      "online": false,
      "desc": "Focuses on infertility and pregnancy-related care.",
      "image": "assets/images/d2.png",
    },
    {
      "name": "Dr. Rahul Sharma",
      "speciality": "Physician",
      "experience": "8 years",
      "online": false,
      "desc": "Expert in internal medicine and primary healthcare.",
      "image": "assets/images/d3.png",
    },
    {
      "name": "Dr. Priya Kapoor",
      "speciality": "Dermatologist",
      "experience": "10 years",
      "online": true,
      "desc": "Skin specialist with focus on acne, rashes, and allergies.",
      "image": "assets/images/d4.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔹 AppBar
      appBar: AppBar(
        backgroundColor: AppColor.colorIntroBG,
        elevation: 0,
        title: Text(
          "$speciality Doctors",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // 🔹 Doctor List
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          final isOnline = doctor["online"] as bool;

          // Show only doctors matching speciality
          // if (doctor["speciality"] != speciality) return const SizedBox.shrink();

          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => DoctorDetailScreen(doctor: doctor),
              //   ),
              // );
            },

            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(doctor["image"]),
                ),
                title: Text(
                  doctor["name"],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Experience: ${doctor["experience"]}"),
                    Text(
                      doctor["desc"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle,
                        size: 14, color: isOnline ? Colors.green : Colors.red),
                    Text(isOnline ? "Online" : "Offline",
                        style: TextStyle(
                            fontSize: 12,
                            color: isOnline ? Colors.green : Colors.red)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
