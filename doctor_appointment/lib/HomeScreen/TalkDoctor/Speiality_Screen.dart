import 'package:flutter/material.dart';

import '../../Utils/AppColor.dart';
import 'Symptom_Screen.dart';

class SpecialityScreen extends StatelessWidget {
  const SpecialityScreen({super.key});

  // Dummy list of doctor specialities
  final List<Map<String, dynamic>> specialities = const [
    {"title": "Physician", "icon": "🧑‍⚕️"},
    {"title": "Gynecologist", "icon": "👩‍🍼"},
    {"title": "Dermatologist", "icon": "💆‍♂️"},
    {"title": "Cardiologist", "icon": "❤️"},
    {"title": "Orthopedic", "icon": "🦴"},
    {"title": "Pediatrician", "icon": "👶"},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Speciality"),
        backgroundColor: AppColor.colorIntroBG,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView.builder(
        itemCount: specialities.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade50,
                radius: 25,
                child: Text(
                  specialities[index]["icon"]!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                specialities[index]["title"]!,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SymptomScreen(
                      speciality: specialities[index]["title"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
