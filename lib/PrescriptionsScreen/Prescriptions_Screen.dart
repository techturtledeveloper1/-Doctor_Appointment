import 'package:doctor_appointment/Utils/ColorConstant.dart';
import 'package:flutter/material.dart';

import 'PrescriptionDetail_Screen.dart';
import 'medicalStore_Screen.dart';

class PrescriptionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> prescriptions = [
    {
      "doctor": "Dr. Priya Sharma",
      "specialty": "Cardiologist",
      "date": "12 Sep 2025",
      "medicines": ["Aspirin 75mg", "Atorvastatin 10mg"],
    },
    {
      "doctor": "Dr. Raj Mehta",
      "specialty": "Dermatologist",
      "date": "02 Sep 2025",
      "medicines": ["Cetirizine 10mg", "Hydrocortisone Cream"],
    },
    {
      "doctor": "Dr. Neha Patel",
      "specialty": "Neurologist",
      "date": "20 Aug 2025",
      "medicines": ["Gabapentin 300mg", "Vitamin B12"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      // appBar: AppBar(
      //   title: Text("Digital Prescriptions"),
      //   centerTitle: true,
      //   backgroundColor: ColorConstant.colorIntroBG,
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.add, color: Colors.white), // Add button
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => MedicalStoreListScreen()),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: prescriptions.isEmpty
          ? Center(
        child: Text(
          "No prescriptions available",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = prescriptions[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Doctor Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage("assets/Images/d2.png"),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prescription["doctor"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text(prescription["specialty"],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      Text(
                        prescription["date"],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  /// Medicines
                  Text("Medicines:",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  SizedBox(height: 6),
                  ...prescription["medicines"]
                      .map<Widget>((med) => Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(Icons.circle,
                            size: 8, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(med,
                                style: TextStyle(fontSize: 14))),
                      ],
                    ),
                  ))
                      .toList(),

                  SizedBox(height: 12),

                  /// Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PrescriptionDetailScreen(
                                doctor: prescription["doctor"],
                                specialty: prescription["specialty"],
                                date: prescription["date"],
                                medicines: List<String>.from(prescription["medicines"]),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.visibility,color: ColorConstant.colorIntroBG,),
                        label: Text("View",style: TextStyle(color: ColorConstant.colorIntroBG)),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Downloading prescription PDF...")),
                          );
                        },
                        icon: Icon(Icons.download,color: ColorConstant.colorIntroBG),
                        label: Text("Download",style: TextStyle(color: ColorConstant.colorIntroBG)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
