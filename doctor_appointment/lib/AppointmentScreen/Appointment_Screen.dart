import 'dart:async';
import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/ConsultScreen/Consult_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:doctor_appointment/screen/DashBoard/DashBoard.dart';
import 'package:doctor_appointment/HomeScreen/ConsultPsychiatristScreen/ConsultPsychiatrist_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';

class AppointmentCalendarScreen extends StatefulWidget {
  @override
  _AppointmentCalendarScreenState createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Timer? _timer;
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isActionLoading = false;

  Map<String, List<Map<String, dynamic>>> appointmentsByDate = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadAppointmentsFromAPI();

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  Future<void> _loadAppointmentsFromAPI() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var response = await ApiService().callGetCalanderScreenList();

      if (response != null && response["success"] == true) {
        _processApiResponse(response);
      } else {
        setState(() {
          _errorMessage = response?["message"] ?? "Failed to load appointments";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading appointments: $e";
        _isLoading = false;
      });
      print("❌ API Error: $e");
    }
  }

  void _processApiResponse1(Map<String, dynamic> response) {
    Map<String, List<Map<String, dynamic>>> processedAppointments = {};

    if (response["data"] != null && response["data"] is List) {
      for (var dateGroup in response["data"]) {
        String dateKey = dateGroup["_id"];

        if (dateGroup["appointments"] != null &&
            dateGroup["appointments"] is List) {
          List<Map<String, dynamic>> appointmentsForDate = [];

          for (var appointment in dateGroup["appointments"]) {
            // DEBUG: Print raw appointment data
            print("📦 Raw Appointment: ${appointment["_id"]}");
            print("   Appointment Date: ${appointment["appointmentDate"]}");
            print("   Appointment Time: ${appointment["appointmentTime"]}");

            // Get the appointment time (handle different formats)
            String rawTime = appointment["appointmentTime"] ?? "";
            String rawDate = appointment["appointmentDate"] ?? "";

            // Create a proper DateTime object
            DateTime appointmentDateTime = _createDateTimeFromApi(
              rawDate,
              rawTime,
            );

            Map<String, dynamic> processedAppointment = {
              "id": appointment["_id"],
              "doctor": appointment["doctor"]?["fullName"] ?? "Doctor",
              "specialty":
                  appointment["doctor"]?["specialization"] ?? "Specialist",
              "hospital": appointment["hospital"]?["name"] ?? "Virtual Clinic",
              "location": appointment["hospital"]?["location"] ?? "Online",
              "patientId": appointment["patientId"] ?? "",
              "time": _formatTime(rawTime),
              "rawTime": rawTime,
              "rawDate": rawDate,
              "status": "Confirmed",
              "type": "Consultation",
              "image": _getDoctorImage(appointment["doctor"]?["profile_photo"]),
              "appointmentDate": rawDate,
              "appointmentDateTime":
                  appointmentDateTime, // Store the actual DateTime
              "rawAppointment": appointment,
            };
            appointmentsForDate.add(processedAppointment);
          }

          String formattedDateKey = _convertToYMD(dateKey);
          processedAppointments[formattedDateKey] = appointmentsForDate;
        }
      }
    }

    setState(() {
      appointmentsByDate = processedAppointments;
      _isLoading = false;
    });

    print(
      "✅ Loaded ${processedAppointments.length} date groups with appointments",
    );
  }

  void _processApiResponse(Map<String, dynamic> response) {
    Map<String, List<Map<String, dynamic>>> processedAppointments = {};

    print("📡 Processing API Response...");

    if (response["data"] != null && response["data"] is List) {
      for (var dateGroup in response["data"]) {
        String dateKey = dateGroup["_id"];

        if (dateGroup["appointments"] != null &&
            dateGroup["appointments"] is List) {
          List<Map<String, dynamic>> appointmentsForDate = [];

          for (var appointment in dateGroup["appointments"]) {
            // 🔍 Try multiple possible field names for time
            String rawTime =
                appointment["appointmentTime"] ??
                appointment["time"] ??
                appointment["slotTime"] ??
                appointment["startTime"] ??
                appointment["bookingTime"] ??
                "";

            // 🔍 Try multiple possible field names for date
            String rawDate =
                appointment["appointmentDate"] ??
                appointment["date"] ??
                appointment["bookingDate"] ??
                appointment["slotDate"] ??
                "";

            // 🔍 If date is in the dateKey format (dd-MM-yyyy), use that
            if (rawDate.isEmpty && dateKey.isNotEmpty) {
              // Convert dateKey from "dd-MM-yyyy" to "yyyy-MM-dd"
              List<String> dateParts = dateKey.split('-');
              if (dateParts.length == 3) {
                rawDate = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
              }
            }

            print("⏰ Extracted Time: '$rawTime'");
            print("📅 Extracted Date: '$rawDate'");

            // Create DateTime object
            DateTime appointmentDateTime;
            if (rawTime.isNotEmpty && rawDate.isNotEmpty) {
              appointmentDateTime = _createDateTimeFromApi(rawDate, rawTime);
            } else {
              // If no time, use a default (current time + 1 hour for testing)
              print("⚠️ No time found! Using default time for testing");
              appointmentDateTime = DateTime.now().add(Duration(hours: 1));
            }

            Map<String, dynamic> processedAppointment = {
              "id": appointment["_id"] ?? "",
              "doctor":
                  appointment["doctor"]?["fullName"] ??
                  appointment["doctorName"] ??
                  appointment["doctor_name"] ??
                  "Doctor",
              "specialty":
                  appointment["doctor"]?["specialization"] ??
                  appointment["specialty"] ??
                  "Specialist",
              "hospital":
                  appointment["hospital"]?["name"] ??
                  appointment["hospitalName"] ??
                  "Virtual Clinic",
              "location":
                  appointment["hospital"]?["location"] ??
                  appointment["location"] ??
                  "Online",
              "patientId":
                  appointment["patientId"] ?? appointment["patient_id"] ?? "",
              "time": _formatTime(rawTime),
              "rawTime": rawTime,
              "rawDate": rawDate,
              "status": appointment["status"] ?? "Confirmed",
              "type": "Consultation",
              "image": _getDoctorImage(
                appointment["doctor"]?["profile_photo"] ??
                    appointment["doctorImage"] ??
                    null,
              ),
              "appointmentDate": rawDate,
              "appointmentDateTime": appointmentDateTime,
              "rawAppointment": appointment,
            };

            appointmentsForDate.add(processedAppointment);
          }

          String formattedDateKey = _convertToYMD(dateKey);
          processedAppointments[formattedDateKey] = appointmentsForDate;
        }
      }
    }

    setState(() {
      appointmentsByDate = processedAppointments;
      _isLoading = false;
    });

    print("✅ Loaded ${processedAppointments.length} date groups");
  }

  DateTime _createDateTimeFromApi(String dateStr, String timeStr) {
    try {
      DateTime dateTime = DateTime.now();

      // Parse date (format: "2025-11-04T00:00:00.000Z" or "2025-11-04")
      if (dateStr.isNotEmpty) {
        if (dateStr.contains('T')) {
          dateTime = DateTime.parse(dateStr);
        } else {
          List<String> dateParts = dateStr.split('-');
          if (dateParts.length == 3) {
            dateTime = DateTime(
              int.parse(dateParts[0]),
              int.parse(dateParts[1]),
              int.parse(dateParts[2]),
            );
          }
        }
      }

      // Parse time (format: "10:16" or "14:30")
      if (timeStr.isNotEmpty && timeStr.contains(':')) {
        List<String> timeParts = timeStr.split(':');
        if (timeParts.length >= 2) {
          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);
          dateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            hour,
            minute,
          );
        }
      }

      print("✅ Created DateTime: $dateTime");
      return dateTime;
    } catch (e) {
      print("❌ DateTime parse error: $e");
      return DateTime.now().add(Duration(hours: 1));
    }
  }

  String _formatTime(String time) {
    if (time.isEmpty) return "Time not set";
    try {
      List<String> parts = time.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        String period = hour < 12 ? 'AM' : 'PM';
        int displayHour = hour % 12;
        if (displayHour == 0) displayHour = 12;
        return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
      }
    } catch (e) {
      print("Time format error: $e");
    }
    return time;
  }

  String _getDoctorImage(String? profilePhoto) {
    if (profilePhoto == null || profilePhoto.isEmpty) {
      return "audio/images/default_doctor.png";
    }
    if (profilePhoto.startsWith('http')) {
      return profilePhoto;
    }
    return "https://doctor-appointment-booking-backend-9iif.onrender.com/doctor/$profilePhoto";
  }

  String _convertToYMD(String ddMMyyyy) {
    try {
      List<String> parts = ddMMyyyy.split('-');
      if (parts.length == 3) {
        return "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    } catch (e) {
      print("Date conversion error: $e");
    }
    return ddMMyyyy;
  }

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    String dateKey = DateFormat('yyyy-MM-dd').format(day);
    return appointmentsByDate[dateKey] ?? [];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget appointmentCard({
    required String doctorName,
    required String specialty,
    required String time,
    required String status,
    required String type,
    required String image,

    required VoidCallback onJoin,
    required VoidCallback onReschedule,
    required VoidCallback onCancel,
    required Map<String, dynamic> rawAppointment,
  }) {
    // bool isCancelled = status.toLowerCase() == "cancelled";
    bool isCancelled = status.toLowerCase().contains("cancel");
    bool isConfirmed = status.toLowerCase() == "confirmed";
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCancelled ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCancelled ? Colors.red.shade100 : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: image.startsWith("http")
                    ? NetworkImage(image) as ImageProvider
                    : AssetImage(image),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      specialty,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isConfirmed && !isCancelled && !_isActionLoading)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorIntroBG,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: onJoin,
                  child: Text(
                    "Join Call",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(status)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    // onPressed: onReschedule,
                    onPressed: (_isActionLoading || isCancelled)
                        ? null
                        : onReschedule,
                    child: Text(
                      "Reschedule",
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    // onPressed: onCancel,
                    onPressed: (_isActionLoading || isCancelled)
                        ? null
                        : onCancel,
                    child: Text(
                      // "Cancel",
                      isCancelled ? "Cancelled" : "Cancel",

                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    String s = status.toLowerCase();

    if (s.contains("confirm")) return Colors.green;
    if (s.contains("pending")) return Colors.orange;
    if (s.contains("cancel")) return Colors.red;

    return Colors.grey;
  }

  Color _getStatusColor1(String status) {
    switch (status.toLowerCase()) {
      case "confirmed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColor.colorIntroBG),
          SizedBox(height: 16),
          Text(
            "Loading your appointments...",
            style: TextStyle(fontSize: 16, color: AppColor.colorIntroBG),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 16),
          Text(
            _errorMessage,
            style: TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.colorIntroBG,
            ),
            onPressed: _loadAppointmentsFromAPI,
            child: Text("Try Again", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent() {
    List<Map<String, dynamic>> selectedAppointments = _getAppointmentsForDay(
      _selectedDay!,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Appointments",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.colorIntroBG,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 26,
                    color: AppColor.colorIntroBG,
                  ),
                  onPressed: _loadAppointmentsFromAPI,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(Duration(days: 365)),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: _getAppointmentsForDay,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return SizedBox();
                      return Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${events.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppColor.colorIntroBG,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    markersMaxCount: 5,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: AppColor.colorIntroBG,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppColor.colorIntroBG,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppColor.colorIntroBG,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColor.colorIntroBG,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Appointments for ${DateFormat('MMMM d, yyyy').format(_selectedDay!)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.colorIntroBG,
                  ),
                ),
              ],
            ),
          ),

          if (selectedAppointments.isEmpty)
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "No Appointments for this day",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "All your booked appointments will appear here",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

          if (selectedAppointments.isNotEmpty)
            Column(
              children: [
                Text(
                  "${selectedAppointments.length} appointment${selectedAppointments.length > 1 ? 's' : ''}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedAppointments.length,
                  itemBuilder: (context, index) {
                    var appt = selectedAppointments[index];

                    // Use the pre-created DateTime
                    DateTime appointmentDateTime =
                        appt["appointmentDateTime"] ?? DateTime.now();

                    // print("🔍 Opening appointment: ${appt["doctor"]}");
                    // print("📅 Appointment DateTime: $appointmentDateTime");

                    return appointmentCard(
                      doctorName: appt["doctor"] ?? "Doctor",
                      specialty: appt["specialty"] ?? "Specialist",
                      time: appt["time"] ?? "Time not set",
                      status: appt["status"] ?? "Confirmed",
                      type: appt["type"] ?? "Consultation",
                      image: appt["image"] ?? "audio/images/default_doctor.png",
                      onJoin: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConsultScreen(
                              doctorName: appt["doctor"] ?? "Doctor",
                              specialty: appt["specialty"] ?? "Specialist",
                              hospital: appt["hospital"] ?? "Virtual Hospital",
                              location: appt["location"] ?? "Online",
                              appointmentTime: appointmentDateTime,
                              image:
                                  appt["image"] ??
                                  "audio/images/default_doctor.png",
                              appointmentId: appt["id"] ?? "",
                              patientId: appt["patientId"] ?? "",
                              status: appt["status"],
                            ),
                          ),
                        );
                      },
                      // onReschedule: () {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text(
                      //         "Reschedule functionality coming soon",
                      //       ),
                      //     ),
                      //   );
                      // },
                      // onCancel: () {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Text("Cancel functionality coming soon"),
                      //     ),
                      //   );
                      // },
                      onReschedule: () => _rescheduleAppointment(appt),
                      onCancel: () => _cancelAppointment(appt),
                      rawAppointment: appt["rawAppointment"] ?? {},
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _cancelAppointment(Map<String, dynamic> appointment) async {
    if (appointment["status"].toString().toLowerCase().contains("cancel")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This appointment is already cancelled"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    TextEditingController reasonController = TextEditingController();
    String selectedCancelledBy = "patient"; // Default value

    // Show confirmation dialog with reason input
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text("Cancel Appointment"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Are you sure you want to cancel this appointment?",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "👨‍⚕️ ${appointment["doctor"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("📅 ${appointment["time"]}"),
                      Text("🏥 ${appointment["hospital"]}"),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Reason for cancellation:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText:
                        "Enter reason (e.g., Mind Change, Schedule conflict)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 12),
                Text(
                  "Cancelled by:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text("Patient"),
                        value: "patient",
                        groupValue: selectedCancelledBy,
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedCancelledBy = value!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text("Doctor"),
                        value: "doctor",
                        groupValue: selectedCancelledBy,
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedCancelledBy = value!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "This action cannot be undone.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No, Keep It", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Yes, Cancel", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    // Get reason text
    String reason = reasonController.text.trim();
    if (reason.isEmpty) {
      reason = "Cancelled by $selectedCancelledBy";
    }

    // Show loading
    setState(() => _isActionLoading = true);

    try {
      // Call API to cancel appointment with reason
      final response = await ApiService().cancelAppointment(
        appointment["id"],
        reason: reason,
        cancelledBy: selectedCancelledBy,
      );

      print("Cancel Response: $response");

      if (response["success"] == true) {
        // ✅ Update local state - change status to cancelled
        setState(() {
          //   // Find and update the appointment status
          //   appointmentsByDate.forEach((date, appointments) {
          //     for (var item in appointments) {
          //       if (item["id"] == appointment["id"]) {
          //         item["status"] = "cancelled";
          //         // Also update raw appointment if needed
          //         if (item["rawAppointment"] != null) {
          //           item["rawAppointment"]["status"] = "cancelled";
          //         }
          //       }
          //     }
          //   });
          //   // Force rebuild
          //   appointmentsByDate = Map.from(appointmentsByDate);
          // });
          // await _loadAppointmentsFromAPI(); // This will fetch fresh data
          for (var date in appointmentsByDate.keys) {
            for (var item in appointmentsByDate[date]!) {
              if (item["id"] == appointment["id"]) {
                item["status"] = "cancelled";
                // Also update raw appointment if needed
                if (item["rawAppointment"] != null) {
                  item["rawAppointment"]["status"] = "cancelled";
                }
                break;
              }
            }
          }
          // Force rebuild
          appointmentsByDate = Map.from(appointmentsByDate);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    response["message"] ?? "Appointment cancelled successfully",
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Optional: Refresh appointments from API
        // await _loadAppointmentsFromAPI();
      } else {
        throw Exception(response["message"] ?? "Failed to cancel");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error cancelling appointment: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  Future<void> _rescheduleAppointment(Map<String, dynamic> appointment) async {
    // Select new date
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.colorIntroBG,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    // Select new time
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.colorIntroBG,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newTime == null) return;

    // Format date as "YYYY-MM-DD"
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

    // Format time as "HH:MM" (24-hour format)
    String formattedTime =
        "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Reschedule Appointment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to reschedule this appointment?"),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("👨‍⚕️ ${appointment["doctor"]}"),
                  SizedBox(height: 5),
                  Text("📅 From: ${appointment["time"]}"),
                  Text(
                    "📅 To: ${DateFormat('dd MMM, hh:mm a').format(DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute))}",
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.colorIntroBG,
            ),
            child: Text("Confirm Reschedule"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    setState(() => _isActionLoading = true);

    try {
      // Call API to reschedule appointment
      final response = await ApiService().rescheduleAppointmentApi(
        appointmentId: appointment["id"],
        newDate: formattedDate,
        newTime: formattedTime,
      );

      print("Reschedule Response: $response");

      if (response["success"] == true) {
        // Update local data
        setState(() {
          // Remove from old date
          String oldDateKey = DateFormat('yyyy-MM-dd').format(_selectedDay!);
          if (appointmentsByDate.containsKey(oldDateKey)) {
            appointmentsByDate[oldDateKey]!.removeWhere(
              (item) => item["id"] == appointment["id"],
            );
            if (appointmentsByDate[oldDateKey]!.isEmpty) {
              appointmentsByDate.remove(oldDateKey);
            }
          }

          // Add to new date
          String newDateKey = DateFormat('yyyy-MM-dd').format(newDate);
          Map<String, dynamic> updatedAppointment = Map.from(appointment);
          updatedAppointment["time"] = _formatTime(formattedTime);
          updatedAppointment["rawTime"] = formattedTime;
          updatedAppointment["rawDate"] = formattedDate;
          updatedAppointment["appointmentDateTime"] = DateTime(
            newDate.year,
            newDate.month,
            newDate.day,
            newTime.hour,
            newTime.minute,
          );

          if (appointmentsByDate.containsKey(newDateKey)) {
            appointmentsByDate[newDateKey]!.add(updatedAppointment);
          } else {
            appointmentsByDate[newDateKey] = [updatedAppointment];
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    response["message"] ??
                        "Appointment rescheduled to ${DateFormat('dd MMM, hh:mm a').format(DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute))}",
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw Exception(response["message"] ?? "Failed to reschedule");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error rescheduling: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
          ? _buildErrorState()
          : _buildCalendarContent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.colorIntroBG,
        child: Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ConsultPsychiatristScreen(specializationId: ''),
            ),
          );
        },
      ),
    );
  }
}

// class AppointmentCalendarScreen extends StatefulWidget {
//   @override
//   _AppointmentCalendarScreenState createState() =>
//       _AppointmentCalendarScreenState();
// }
//
// class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Timer? _timer;
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   Map<String, List<Map<String, dynamic>>> appointmentsByDate = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _loadAppointmentsFromAPI();
//
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       setState(() {});
//     });
//   }
//
//   Future<void> _loadAppointmentsFromAPI() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     try {
//       var response = await ApiService().callGetCalanderScreenList();
//
//       if (response != null && response["success"] == true) {
//         _processApiResponse(response);
//       } else {
//         setState(() {
//           _errorMessage = response?["message"] ?? "Failed to load appointments";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Error loading appointments: $e";
//         _isLoading = false;
//       });
//       print("❌ API Error: $e");
//     }
//   }
//
//   void _processApiResponse(Map<String, dynamic> response) {
//     Map<String, List<Map<String, dynamic>>> processedAppointments = {};
//
//     if (response["data"] != null && response["data"] is List) {
//       for (var dateGroup in response["data"]) {
//         String dateKey = dateGroup["_id"]; // This is in "dd-MM-yyyy" format
//
//         if (dateGroup["appointments"] != null &&
//             dateGroup["appointments"] is List) {
//           List<Map<String, dynamic>> appointmentsForDate = [];
//
//           for (var appointment in dateGroup["appointments"]) {
//             // Convert API response to our app format
//             Map<String, dynamic> processedAppointment = {
//               "id": appointment["_id"],
//               "doctor": appointment["doctor"]["fullName"] ?? "Doctor",
//               "specialty":
//                   appointment["doctor"]["specialization"] ?? "Specialist",
//               "time": _formatTime(appointment["appointmentTime"]),
//               "status": "Confirmed", // Default status since API doesn't provide
//               "type": "Consultation", // Default type
//               "image": _getDoctorImage(appointment["doctor"]["profile_photo"]),
//               "appointmentDate": _parseApiDate(appointment["appointmentDate"]),
//               "rawAppointment": appointment, // Keep original data
//             };
//             appointmentsForDate.add(processedAppointment);
//           }
//
//           // Convert date key to YYYY-MM-DD format for calendar
//           String formattedDateKey = _convertToYMD(dateKey);
//           processedAppointments[formattedDateKey] = appointmentsForDate;
//         }
//       }
//     }
//
//     setState(() {
//       appointmentsByDate = processedAppointments;
//       _isLoading = false;
//     });
//
//     print(
//       "✅ Loaded ${processedAppointments.length} date groups with appointments",
//     );
//   }
//
//   String _formatTime(String time) {
//     try {
//       // Handle time format (e.g., "10:16" -> "10:16 AM")
//       List<String> parts = time.split(':');
//       if (parts.length == 2) {
//         int hour = int.parse(parts[0]);
//         int minute = int.parse(parts[1]);
//         String period = hour < 12 ? 'AM' : 'PM';
//         int displayHour = hour % 12;
//         if (displayHour == 0) displayHour = 12;
//         return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
//       }
//     } catch (e) {
//       print("Time format error: $e");
//     }
//     return time;
//   }
//
//   String _getDoctorImage(String? profilePhoto) {
//     if (profilePhoto == null || profilePhoto.isEmpty) {
//       return "audio/images/default_doctor.png";
//     }
//
//     // If it's a full URL, use it directly
//     if (profilePhoto.startsWith('http')) {
//       return profilePhoto;
//     }
//
//     // If it's just a filename, construct the full URL
//     return "https://doctor-appointment-booking-backend-9iif.onrender.com/doctor/$profilePhoto";
//   }
//
//   String _parseApiDate(String apiDate) {
//     try {
//       // Convert "2025-11-04T00:00:00.000Z" to "2025-11-04"
//       DateTime date = DateTime.parse(apiDate);
//       return DateFormat('yyyy-MM-dd').format(date);
//     } catch (e) {
//       return apiDate;
//     }
//   }
//
//   String _convertToYMD(String ddMMyyyy) {
//     try {
//       // Convert "04-11-2025" to "2025-11-04"
//       List<String> parts = ddMMyyyy.split('-');
//       if (parts.length == 3) {
//         String day = parts[0];
//         String month = parts[1];
//         String year = parts[2];
//         return "$year-$month-$day";
//       }
//     } catch (e) {
//       print("Date conversion error: $e");
//     }
//     return ddMMyyyy;
//   }
//
//   List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
//     String dateKey = DateFormat('yyyy-MM-dd').format(day);
//     return appointmentsByDate[dateKey] ?? [];
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   Widget appointmentCard({
//     required String doctorName,
//     required String specialty,
//     required String time,
//     required String status,
//     required String type,
//     required String image,
//     required VoidCallback onJoin,
//     required VoidCallback onReschedule,
//     required VoidCallback onCancel,
//     required Map<String, dynamic> rawAppointment,
//   }) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Top Row
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 22,
//                 backgroundImage: image.startsWith("http")
//                     ? NetworkImage(image) as ImageProvider
//                     : image.startsWith("audio/")
//                     ? AssetImage(image)
//                     : AssetImage("audio/images/default_doctor.png"),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       doctorName,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       specialty,
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, size: 14, color: Colors.grey),
//                         SizedBox(width: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_today,
//                           size: 14,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(width: 4),
//                         Text(
//                           type,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               if (status == "Confirmed")
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.colorIntroBG,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   ),
//                   onPressed: onJoin,
//                   child: Text(
//                     "Join Call",
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 12),
//
//           /// Bottom Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(status).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: _getStatusColor(status)),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: _getStatusColor(status),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                     onPressed: onReschedule,
//                     child: Text(
//                       "Reschedule",
//                       style: TextStyle(color: Colors.blue, fontSize: 12),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   TextButton(
//                     onPressed: onCancel,
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.red, fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case "confirmed":
//         return Colors.green;
//       case "pending":
//         return Colors.orange;
//       case "cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: AppColor.colorIntroBG),
//           SizedBox(height: 16),
//           Text(
//             "Loading your appointments...",
//             style: TextStyle(fontSize: 16, color: AppColor.colorIntroBG),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 50, color: Colors.red),
//           SizedBox(height: 16),
//           Text(
//             _errorMessage,
//             style: TextStyle(fontSize: 16, color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.colorIntroBG,
//             ),
//             onPressed: _loadAppointmentsFromAPI,
//             child: Text("Try Again", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCalendarContent() {
//     List<Map<String, dynamic>> selectedAppointments = _getAppointmentsForDay(
//       _selectedDay!,
//     );
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           /// Title
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "My Appointments",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: AppColor.colorIntroBG,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.refresh,
//                     size: 26,
//                     color: AppColor.colorIntroBG,
//                   ),
//                   onPressed: _loadAppointmentsFromAPI,
//                 ),
//               ],
//             ),
//           ),
//
//           /// Calendar
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TableCalendar(
//                   firstDay: DateTime.now().subtract(Duration(days: 365)),
//                   lastDay: DateTime.now().add(Duration(days: 365)),
//                   focusedDay: _focusedDay,
//                   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                   calendarFormat: _calendarFormat,
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       _selectedDay = selectedDay;
//                       _focusedDay = focusedDay;
//                     });
//                   },
//                   onPageChanged: (focusedDay) {
//                     setState(() {
//                       _focusedDay = focusedDay;
//                     });
//                   },
//
//                   eventLoader: _getAppointmentsForDay,
//
//                   calendarBuilders: CalendarBuilders(
//                     markerBuilder: (context, day, events) {
//                       if (events.isEmpty) return SizedBox();
//
//                       return Positioned(
//                         right: 4,
//                         top: 4,
//                         child: Container(
//                           padding: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.red, // badge color
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text(
//                             "${events.length}",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//
//                   calendarStyle: CalendarStyle(
//                     selectedDecoration: BoxDecoration(
//                       color: AppColor.colorIntroBG,
//                       shape: BoxShape.circle,
//                     ),
//                     todayDecoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       shape: BoxShape.circle,
//                     ),
//                     outsideDaysVisible: false,
//                     markersMaxCount: 5,
//                   ),
//
//                   headerStyle: HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,
//                     titleTextStyle: TextStyle(
//                       color: AppColor.colorIntroBG,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     leftChevronIcon: Icon(
//                       Icons.chevron_left,
//                       color: AppColor.colorIntroBG,
//                     ),
//                     rightChevronIcon: Icon(
//                       Icons.chevron_right,
//                       color: AppColor.colorIntroBG,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           /// Selected Date Header
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   color: AppColor.colorIntroBG,
//                   size: 20,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   "Appointments for ${DateFormat('MMMM d, yyyy').format(_selectedDay!)}",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColor.colorIntroBG,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// No Appointment Message
//           if (selectedAppointments.isEmpty)
//             Container(
//               margin: EdgeInsets.all(20),
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.calendar_today,
//                     size: 50,
//                     color: Colors.grey.shade400,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "No Appointments for this day",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "All your booked appointments will appear here",
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//                   ),
//                 ],
//               ),
//             ),
//
//           /// Appointment List
//           if (selectedAppointments.isNotEmpty)
//             Column(
//               children: [
//                 Text(
//                   "${selectedAppointments.length} appointment${selectedAppointments.length > 1 ? 's' : ''}",
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//                 SizedBox(height: 8),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: selectedAppointments.length,
//                   itemBuilder: (context, index) {
//                     var appt = selectedAppointments[index];
//                     return appointmentCard(
//                       doctorName: appt["doctor"] ?? "Doctor",
//                       specialty: appt["specialty"] ?? "Specialist",
//                       time: appt["time"] ?? "Time not set",
//                       status: appt["status"] ?? "Confirmed",
//                       type: appt["type"] ?? "Consultation",
//                       image:
//                           appt["image"] ?? "audio/images/default_doctor.png",
//                       onJoin: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => DashBoardNew(2, false, false),
//                           ),
//                         );
//                       },
//                       onReschedule: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               "Reschedule functionality coming soon",
//                             ),
//                           ),
//                         );
//                       },
//                       onCancel: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Cancel functionality coming soon"),
//                           ),
//                         );
//                       },
//                       rawAppointment: appt["rawAppointment"] ?? {},
//                     );
//                   },
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _isLoading
//           ? _buildLoadingState()
//           : _errorMessage.isNotEmpty
//           ? _buildErrorState()
//           : _buildCalendarContent(),
//
//       /// Floating Action Button
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColor.colorIntroBG,
//         child: Icon(Icons.add, color: Colors.white, size: 30),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) =>
//                   const ConsultPsychiatristScreen(specializationId: ''),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// aa  pehla no code che
//
//   @override
//   _AppointmentCalendarScreenState createState() =>
//       _AppointmentCalendarScreenState();
// }
//
// class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Timer? _timer;
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   Map<String, List<Map<String, dynamic>>> appointmentsByDate = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _loadAppointmentsFromAPI();
//
//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       setState(() {});
//     });
//   }
//
//   Future<void> _loadAppointmentsFromAPI() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     try {
//       var response = await ApiService().callGetCalanderScreenList();
//
//       if (response != null && response["success"] == true) {
//         _processApiResponse(response);
//       } else {
//         setState(() {
//           _errorMessage = response?["message"] ?? "Failed to load appointments";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "Error loading appointments: $e";
//         _isLoading = false;
//       });
//       print("❌ API Error: $e");
//     }
//   }
//
//   void _processApiResponse(Map<String, dynamic> response) {
//     Map<String, List<Map<String, dynamic>>> processedAppointments = {};
//
//     if (response["data"] != null && response["data"] is List) {
//       for (var dateGroup in response["data"]) {
//         String dateKey = dateGroup["_id"];
//
//         if (dateGroup["appointments"] != null &&
//             dateGroup["appointments"] is List) {
//           List<Map<String, dynamic>> appointmentsForDate = [];
//
//           for (var appointment in dateGroup["appointments"]) {
//             final apptMap = Map<String, dynamic>.from(appointment);
//             final doctorMap = Map<String, dynamic>.from(
//               apptMap["doctor"] ?? {},
//             );
//
//             Map<String, dynamic> processedAppointment = {
//               "id": appointment["_id"],
//               "doctor": appointment["doctor"]["fullName"] ?? "Doctor",
//               "specialty":
//                   appointment["doctor"]["specialization"] ?? "Specialist",
//               "time": _formatTime(appointment["appointmentTime"]),
//               "status": "Confirmed",
//               "type": "Consultation",
//               "image": _getDoctorImage(appointment["doctor"]["profile_photo"]),
//               "appointmentDate": _parseApiDate(appointment["appointmentDate"]),
//               "appointmentDateTime": _combineDateTime(
//                 appointment["appointmentDate"],
//                 appointment["appointmentTime"],
//               ),
//               // "rawAppointment": appointment,
//               "rawAppointment": {
//                 ...appointment,
//                 "appointmentDateTime": _combineDateTime(
//                   appointment["appointmentDate"],
//                   appointment["appointmentTime"],
//                 ),
//               },
//             };
//             appointmentsForDate.add(processedAppointment);
//           }
//
//           // Convert date key to YYYY-MM-DD format for calendar
//           String formattedDateKey = _convertToYMD(dateKey);
//           processedAppointments[formattedDateKey] = appointmentsForDate;
//         }
//       }
//     }
//
//     setState(() {
//       appointmentsByDate = processedAppointments;
//       _isLoading = false;
//     });
//
//     print(
//       "✅ Loaded ${processedAppointments.length} date groups with appointments",
//     );
//   }
//
//   DateTime _combineDateTime(String date, String time) {
//     try {
//       final parsedDate = DateTime.parse(date); // 2025-11-04
//       final timeParts = time.split(":");
//
//       int hour = int.parse(timeParts[0]);
//       int minute = int.parse(timeParts[1]);
//
//       return DateTime(
//         parsedDate.year,
//         parsedDate.month,
//         parsedDate.day,
//         hour,
//         minute,
//       );
//     } catch (e) {
//       print("DateTime combine error: $e");
//       return DateTime.now(); // fallback (safe)
//     }
//   }
//
//   String _formatTime(String time) {
//     try {
//       // Handle time format (e.g., "10:16" -> "10:16 AM")
//       List<String> parts = time.split(':');
//       if (parts.length == 2) {
//         int hour = int.parse(parts[0]);
//         int minute = int.parse(parts[1]);
//         String period = hour < 12 ? 'AM' : 'PM';
//         int displayHour = hour % 12;
//         if (displayHour == 0) displayHour = 12;
//         return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
//       }
//     } catch (e) {
//       print("Time format error: $e");
//     }
//     return time;
//   }
//
//   String _getDoctorImage(String? profilePhoto) {
//     if (profilePhoto == null || profilePhoto.isEmpty) {
//       return AppImages.d1;
//     }
//
//     // If it's a full URL, use it directly
//     if (profilePhoto.startsWith('http')) {
//       return profilePhoto;
//     }
//
//     // If it's just a filename, construct the full URL
//     return "https://doctor-appointment-booking-backend-9iif.onrender.com/doctor/$profilePhoto";
//   }
//
//   String _parseApiDate(String apiDate) {
//     try {
//       // Convert "2025-11-04T00:00:00.000Z" to "2025-11-04"
//       DateTime date = DateTime.parse(apiDate);
//       return DateFormat('yyyy-MM-dd').format(date);
//     } catch (e) {
//       return apiDate;
//     }
//   }
//
//   String _convertToYMD(String ddMMyyyy) {
//     try {
//       // Convert "04-11-2025" to "2025-11-04"
//       List<String> parts = ddMMyyyy.split('-');
//       if (parts.length == 3) {
//         String day = parts[0];
//         String month = parts[1];
//         String year = parts[2];
//         return "$year-$month-$day";
//       }
//     } catch (e) {
//       print("Date conversion error: $e");
//     }
//     return ddMMyyyy;
//   }
//
//   List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
//     String dateKey = DateFormat('yyyy-MM-dd').format(day);
//     return appointmentsByDate[dateKey] ?? [];
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   Widget appointmentCard({
//     required String doctorName,
//     required String specialty,
//     required String time,
//     required String status,
//     required String type,
//     required String image,
//     required VoidCallback onJoin,
//     required VoidCallback onReschedule,
//     required VoidCallback onCancel,
//     required Map<String, dynamic> rawAppointment,
//   }) {
//     // DateTime dt = appt["appointmentDateTime"] ?? DateTime.now();
//     // DateTime dt = appt["appointmentDateTime"];
//     // bool canJoin = _canJoinCall(dt);
//     // bool isExpired = _isExpired(dt);
//
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Top Row
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 22,
//                 backgroundImage: image.startsWith("http")
//                     ? NetworkImage(image) as ImageProvider
//                     : image.startsWith("audio/")
//                     ? AssetImage(image)
//                     : AssetImage("audio/images/default_doctor.png"),
//                 // backgroundImage: NetworkImage(appt["image"]),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       doctorName,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       specialty,
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, size: 14, color: Colors.grey),
//                         SizedBox(width: 4),
//                         Text(
//                           time,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_today,
//                           size: 14,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(width: 4),
//                         Text(
//                           type,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               if (status == "Confirmed")
//                 AppButton(
//                   onPressed: onJoin,
//                   // onPressed: canJoin
//                   //     ? onJoin
//                   //     : () {
//                   //         if (isExpired) {
//                   //           ScaffoldMessenger.of(context).showSnackBar(
//                   //             SnackBar(
//                   //               content: Text("Appointment time finished"),
//                   //             ),
//                   //           );
//                   //         } else {
//                   //           ScaffoldMessenger.of(context).showSnackBar(
//                   //             SnackBar(
//                   //               content: Text(
//                   //                 "You can join only at appointment time",
//                   //               ),
//                   //             ),
//                   //           );
//                   //         }
//                   //       },
//                   text: "Join Call",
//                   textStyle: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//             ],
//           ),
//           SizedBox(height: 12),
//
//           /// Bottom Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getStatusColor(status).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: _getStatusColor(status)),
//                 ),
//                 child: Text(
//                   status,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: _getStatusColor(status),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                     onPressed: onReschedule,
//                     child: Text(
//                       "Reschedule",
//                       style: TextStyle(color: Colors.blue, fontSize: 12),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   TextButton(
//                     onPressed: onCancel,
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.red, fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case "confirmed":
//         return Colors.green;
//       case "pending":
//         return Colors.orange;
//       case "cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: AppColor.colorIntroBG),
//           SizedBox(height: 16),
//           Text(
//             "Loading your appointments...",
//             style: TextStyle(fontSize: 16, color: AppColor.colorIntroBG),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 50, color: Colors.red),
//           SizedBox(height: 16),
//           Text(
//             _errorMessage,
//             style: TextStyle(fontSize: 16, color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColor.colorIntroBG,
//             ),
//             onPressed: _loadAppointmentsFromAPI,
//             child: Text("Try Again", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCalendarContent() {
//     if (_selectedDay == null) {
//       return Center(child: Text("No date selected"));
//     }
//     List<Map<String, dynamic>> selectedAppointments = _getAppointmentsForDay(
//       _selectedDay!,
//     );
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "My Appointments",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: AppColor.colorIntroBG,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.refresh,
//                     size: 26,
//                     color: AppColor.colorIntroBG,
//                   ),
//                   onPressed: _loadAppointmentsFromAPI,
//                 ),
//               ],
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TableCalendar(
//                   firstDay: DateTime.now().subtract(Duration(days: 365)),
//                   lastDay: DateTime.now().add(Duration(days: 365)),
//                   focusedDay: _focusedDay,
//                   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                   calendarFormat: _calendarFormat,
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       _selectedDay = selectedDay;
//                       _focusedDay = focusedDay;
//                     });
//                   },
//                   onPageChanged: (focusedDay) {
//                     setState(() {
//                       _focusedDay = focusedDay;
//                     });
//                   },
//
//                   eventLoader: _getAppointmentsForDay,
//
//                   calendarBuilders: CalendarBuilders(
//                     markerBuilder: (context, day, events) {
//                       if (events.isEmpty) return SizedBox();
//
//                       return Positioned(
//                         right: 4,
//                         top: 4,
//                         child: Container(
//                           padding: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.red, // badge color
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text(
//                             "${events.length}",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//
//                   calendarStyle: CalendarStyle(
//                     selectedDecoration: BoxDecoration(
//                       color: AppColor.colorIntroBG,
//                       shape: BoxShape.circle,
//                     ),
//                     todayDecoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       shape: BoxShape.circle,
//                     ),
//                     outsideDaysVisible: false,
//                     markersMaxCount: 5,
//                   ),
//
//                   headerStyle: HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,
//                     titleTextStyle: TextStyle(
//                       color: AppColor.colorIntroBG,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     leftChevronIcon: Icon(
//                       Icons.chevron_left,
//                       color: AppColor.colorIntroBG,
//                     ),
//                     rightChevronIcon: Icon(
//                       Icons.chevron_right,
//                       color: AppColor.colorIntroBG,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           /// Selected Date Header
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   color: AppColor.colorIntroBG,
//                   size: 20,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   "Appointments for ${DateFormat('MMMM d, yyyy').format(_selectedDay!)}",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColor.colorIntroBG,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// No Appointment Message
//           if (selectedAppointments.isEmpty)
//             Container(
//               margin: EdgeInsets.all(20),
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.calendar_today,
//                     size: 50,
//                     color: Colors.grey.shade400,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "No Appointments for this day",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "All your booked appointments will appear here",
//                     style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//                   ),
//                 ],
//               ),
//             ),
//
//           if (selectedAppointments.isNotEmpty)
//             Column(
//               children: [
//                 Text(
//                   "${selectedAppointments.length} appointment${selectedAppointments.length > 1 ? 's' : ''}",
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//                 SizedBox(height: 8),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: selectedAppointments.length,
//                   itemBuilder: (context, index) {
//                     var appt = selectedAppointments[index];
//
//                     return appointmentCard(
//                       doctorName: appt["doctor"] ?? "Doctor",
//                       specialty: appt["specialty"] ?? "Specialist",
//                       time: appt["time"] ?? "Time not set",
//                       status: appt["status"] ?? "Confirmed",
//                       type: appt["type"] ?? "Consultation",
//                       image:
//                           appt["image"] ?? "audio/images/default_doctor.png",
//                       onJoin: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ConsultScreen(
//                               doctorName: appt["doctor"],
//                               specialty: appt["specialty"],
//                               hospital: appt["hospital"] ?? "Hospital",
//                               location:
//                                   appt["location"] ?? "Ahmedabad, Gujarat",
//                               appointmentTime:
//                                   appt["appointmentDateTime"] ?? DateTime.now(),
//                               image: appt["image"] ?? "",
//                               appointmentId: '',
//                               patientId: '',
//                             ),
//                             // builder: (_) => DashBoardNew(2, false, false),
//                           ),
//                         );
//                       },
//                       onReschedule: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               "Reschedule functionality coming soon",
//                             ),
//                           ),
//                         );
//                       },
//                       onCancel: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Cancel functionality coming soon"),
//                           ),
//                         );
//                       },
//                       rawAppointment: appt["rawAppointment"] ?? {},
//                       // appt: appt,
//                     );
//                   },
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _isLoading
//           ? _buildLoadingState()
//           : _errorMessage.isNotEmpty
//           ? _buildErrorState()
//           : _buildCalendarContent(),
//
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColor.colorIntroBG,
//         child: Icon(Icons.add, color: Colors.white, size: 30),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) =>
//                   const ConsultPsychiatristScreen(specializationId: ''),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
