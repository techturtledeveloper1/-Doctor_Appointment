import 'package:flutter/material.dart';
import '../../Utils/AppColor.dart';
import 'DoctorList_Screen.dart';

class SymptomScreen extends StatefulWidget {
  final String speciality;

  const SymptomScreen({super.key, required this.speciality});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  // Symptoms mapped to specialities
  final Map<String, List<String>> symptomsData = {
    "Gynecologist": [
      "Burning Sensation",
      "Irregular Periods",
      "Pelvic Pain",
      "Vaginal Discharge",
      "Menopause Symptoms",
    ],
    "Physician": [
      "Fever",
      "Cough",
      "Headache",
      "Chest Pain",
      "Weakness",
    ],
    "Dermatologist": [
      "Acne",
      "Itching",
      "Rashes",
      "Hair Fall",
      "Skin Allergy",
    ],
  };

  // Track selected symptoms
  final Set<String> _selectedSymptoms = {};

  @override
  Widget build(BuildContext context) {
    final symptoms = symptomsData[widget.speciality] ?? ["General Consultation"];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔹 AppBar
      appBar: AppBar(
        backgroundColor: AppColor.colorIntroBG,
        elevation: 0,
        title: Text(
          widget.speciality,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // 🔹 Symptoms List
      body: ListView.builder(
        itemCount: symptoms.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final symptom = symptoms[index];
          final isSelected = _selectedSymptoms.contains(symptom);

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: AppColor.colorIntroBG.withOpacity(0.1),
                child: Icon(Icons.local_hospital, color: AppColor.colorIntroBG),
              ),
              title: Text(
                symptom,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: Checkbox(
                activeColor: AppColor.colorIntroBG,
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedSymptoms.add(symptom);
                    } else {
                      _selectedSymptoms.remove(symptom);
                    }
                  });
                },
              ),
              onTap: () {
                setState(()
                {
                  if (isSelected) {
                    _selectedSymptoms.remove(symptom);
                  } else {
                    _selectedSymptoms.add(symptom);
                  }
                });
              },
            ),
          );
        },
      ),

      // 🔹 Continue Button
      bottomNavigationBar: _selectedSymptoms.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.colorIntroBG,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorListScreen(
                  speciality: widget.speciality,
                  selectedSymptoms: _selectedSymptoms.toList(),
                ),
              ),
            );
          },
          child: const Text("Continue", style: TextStyle(fontSize: 16)),
        ),
      )
          : null,
    );
  }
}
