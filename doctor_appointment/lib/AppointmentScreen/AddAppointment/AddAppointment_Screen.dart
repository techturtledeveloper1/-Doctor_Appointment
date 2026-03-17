// Add Appointment Screen
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAppointmentScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  AddAppointmentScreen({required this.onSave});

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController doctorCtrl = TextEditingController();
  TextEditingController specialtyCtrl = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String status = "Pending";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: doctorCtrl,
                decoration: InputDecoration(labelText: "Doctor Name"),
                validator: (v) => v!.isEmpty ? "Enter doctor name" : null,
              ),
              TextFormField(
                controller: specialtyCtrl,
                decoration: InputDecoration(labelText: "Specialty"),
              ),
              SizedBox(height: 16),

              // Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "Select Date"
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026),
                        initialDate: DateTime.now(),
                      );
                      if (date != null) setState(() => selectedDate = date);
                    },
                    child: Text("Pick Date"),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Time Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedTime == null
                          ? "Select Time"
                          : selectedTime!.format(context),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) setState(() => selectedTime = time);
                    },
                    child: Text("Pick Time"),
                  ),
                ],
              ),

              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: status,
                items: ["Booked", "Pending"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => status = val!),
                decoration: InputDecoration(labelText: "Status"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedDate != null &&
                      selectedTime != null) {
                    widget.onSave({
                      "doctor": doctorCtrl.text,
                      "specialty": specialtyCtrl.text,
                      "time": selectedTime!.format(context),
                      "status": status,
                      "image": "assets/images/d1.png", // default
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text("Save Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
