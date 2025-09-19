import 'package:flutter/material.dart';
import '../../Utils/ColorConstant.dart';
import 'DoctorDetails/DoctorDetails_Screen.dart';

class ConsultPsychiatristScreen extends StatefulWidget {
  const ConsultPsychiatristScreen({super.key});

  @override
  State<ConsultPsychiatristScreen> createState() => _ConsultPsychiatristScreenState();
}

class _ConsultPsychiatristScreenState extends State<ConsultPsychiatristScreen> {
  String selectedCategory = "Psychiatrist";
  String selectedLanguage = "English";

  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Sarah Jones",
      "specialty": "Psychiatrist",
      "location": "Chicago, IL",
      "image": "assets/Images/d2.png",
      "experience": "10 Years",
      "online": true,
      "desc":
      "Dr. Sarah Jones is a highly experienced psychiatrist specializing in mood disorders, anxiety, and trauma-focused therapy.",
      "availability": {
        "2025-09-15": ["10:00 AM", "02:30 PM", "05:00 PM"],
        "2025-09-16": ["11:00 AM", "04:00 PM"],
        "2025-09-17": [],
      }
    },
    {
      "name": "Dr. Mark Smith",
      "specialty": "Psychiatrist",
      "location": "New York, NY",
      "image": "assets/Images/d1.png",
      "experience": "8 Years",
      "online": false,
      "desc":
      "Dr. Mark Smith helps patients manage depression and stress with evidence-based treatments and counseling.",
      "availability": {
        "2025-09-15": ["09:30 AM", "03:00 PM"],
        "2025-09-16": ["12:00 PM", "06:00 PM"],
      }
    },
    {
      "name": "Dr. Emily Brown",
      "specialty": "Psychiatrist",
      "location": "Los Angeles, CA",
      "image": "assets/Images/d4.png",
      "experience": "12 Years",
      "online": true,
      "desc":
      "Dr. Emily Brown has extensive expertise in adolescent psychiatry and works with families to support mental health.",
      "availability": {
        "2025-09-15": ["11:00 AM"],
        "2025-09-16": [],
        "2025-09-17": ["02:00 PM", "04:30 PM"],
      }
    },
    {
      "name": "Dr. James Wilson",
      "specialty": "Psychiatrist",
      "location": "Austin, TX",
      "image": "assets/Images/d3.png",
      "experience": "15 Years",
      "online": false,
      "desc":
      "Dr. James Wilson is known for his compassionate care and specializes in treating severe mental health conditions.",
      "availability": {
        "2025-09-15": [],
        "2025-09-16": ["10:30 AM", "01:30 PM"],
      }
    },
  ];



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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
            // const SizedBox(height: 16),
            //
            // // Category Tabs
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: ["Psychiatrist", "Therapist", "Psychologist"]
            //         .map((category) => Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 6),
            //       child: ChoiceChip(
            //         label: Text(category),
            //         selected: selectedCategory == category,
            //         onSelected: (val) {
            //           setState(() => selectedCategory = category);
            //         },
            //         selectedColor: ColorConstant.colorIntroBG,
            //         labelStyle: TextStyle(
            //           color: selectedCategory == category
            //               ? Colors.white
            //               : Colors.black,
            //         ),
            //       ),
            //     ))
            //         .toList(),
            //   ),
            // ),
            const SizedBox(height: 16),

            // Doctor List
            Expanded(
              child: ListView.builder(
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
                              Text(doctor["name"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(doctor["specialty"],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 14)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(doctor["location"],
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.colorIntroBG,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorDetailScreen(doctor: doctor),
                              ),
                            );
                          },
                          child: const Text("Consult"),
                        )

                      ],
                    ),
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
