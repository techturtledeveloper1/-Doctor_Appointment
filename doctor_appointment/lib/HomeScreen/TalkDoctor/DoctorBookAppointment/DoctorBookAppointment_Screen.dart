import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final Function(Map<String, dynamic>) onAppointmentBooked; // callback

  const BookAppointmentScreen({
    super.key,
    required this.doctor,
    required this.onAppointmentBooked,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _appointmentType = 'Video Call'; // default type
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.colorPrimary,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColor.colorPrimary),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.colorPrimary,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          timePickerTheme: TimePickerThemeData(
            dialHandColor: AppColor.colorPrimary,
            hourMinuteTextColor: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Appointment",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.colorPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Doctor Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(widget.doctor["image"]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doctor["name"],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.colorPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.doctor["speciality"],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Experience: ${widget.doctor["experience"] ?? 'N/A'}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: widget.doctor["online"]
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.doctor["online"] ? "Online" : "Offline",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.doctor["online"]
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Form Fields
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColor.colorPrimary,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.colorPrimary),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.home,
                        color: AppColor.colorPrimary,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.colorPrimary),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your address' : null,
                  ),
                  const SizedBox(height: 16),
                  // 🔹 Appointment Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _appointmentType,
                    items: ['Chat', 'Voice Call', 'Video Call', 'In-Clinic']
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _appointmentType = value!),
                    decoration: InputDecoration(
                      labelText: 'Appointment Type',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.medical_services,
                        color: AppColor.colorPrimary,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.colorPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      color: AppColor.colorPrimary,
                    ),
                    title: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    ),
                    onTap: _pickDate,
                    tileColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Icon(
                      Icons.access_time,
                      color: AppColor.colorPrimary,
                    ),
                    title: Text(
                      _selectedTime == null
                          ? 'Select Time'
                          : 'Time: ${_selectedTime!.format(context)}',
                    ),
                    onTap: _pickTime,
                    tileColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.colorPrimary,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedDate == null || _selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select date and time'),
                              ),
                            );
                            return;
                          }

                          Map<String, dynamic> newAppointment = {
                            "doctor": widget.doctor["name"],
                            "specialty": widget.doctor["speciality"],
                            "time": "${_selectedTime!.format(context)}",
                            "type": _appointmentType,
                            "status": "Booked",
                            "date": DateFormat(
                              'yyyy-MM-dd',
                            ).format(_selectedDate!),
                            "image": widget.doctor["image"],
                          };

                          widget.onAppointmentBooked(newAppointment);

                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Book Appointment",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
