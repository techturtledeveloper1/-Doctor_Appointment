import 'package:flutter/material.dart';
import '../../../Utils/ColorConstant.dart';
import '../../TalkDoctor/DoctorBookAppointment/DoctorBookAppointment_Screen.dart';
import '../DoctorBook/DoctorBook_Screen.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  final List<Map<String, dynamic>> availableDoctors = [
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

  DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor; // ✅ use doctor map, not the whole list

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Doctor Details",
          style: TextStyle(
            color: ColorConstant.colorIntroBG,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Image
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(doctor["image"]),
            ),
            const SizedBox(height: 16),

            // Doctor Name
            Text(
              doctor["name"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            // Specialty + Location
            Text(
              "${doctor["specialty"]} • ${doctor["location"]}",
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),

            const SizedBox(height: 8),
            Text("Experience: ${doctor["experience"]}"),
            const SizedBox(height: 6),
            Text(
              doctor["online"] ? "Online Now" : "Offline",
              style: TextStyle(
                color: doctor["online"] ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              doctor["desc"],
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),

            const SizedBox(height: 20),

            // Date Picker
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade50,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _selectedTime = null; // reset time on new date
                    });
                  }
                },
                child: Text(
                  _selectedDate == null
                      ? "Select Date"
                      : "Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Time Slots for selected date
            if (_selectedDate != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Available Slots",
                  style: TextStyle(
                    color: ColorConstant.colorIntroBG,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Builder(
                builder: (context) {
                  final key = _formatDate(_selectedDate!);
                  final slots = doctor["availability"][key] ?? [];

                  // If no slots, show alternative doctors
                  if (slots.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "No slots available for this day.",
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        _alternativeDoctorsList(),
                      ],
                    );
                  }

                  // Else show slot buttons
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: slots.map<Widget>((time) {
                      final isSelected = _selectedTime == time;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTime = time;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorConstant.colorIntroBG
                                : Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              color:
                              isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],

            const SizedBox(height: 30),

            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _selectedDate != null && _selectedTime != null
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorBookAppointmentScreen(
                        doctor: doctor,
                        selectedDate:
                        "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        selectedTime: _selectedTime!,
                      ),
                    ),
                  );
                }
                    : null,
                child: const Text("Book Appointment",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alternativeDoctorsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(
          "Other Available Doctors",
          style: TextStyle(
            color: ColorConstant.colorIntroBG,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.availableDoctors.length,
            itemBuilder: (context, i) {
              final doc = widget.availableDoctors[i];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorDetailScreen(doctor: doc), // ✅ fixed
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(doc["image"]),
                      ),
                      const SizedBox(height: 6),
                      Text(doc["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14)),
                      Text(doc["specialty"],
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
