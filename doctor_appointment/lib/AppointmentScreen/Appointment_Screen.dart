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

  bool _canJoinCall(DateTime appointmentDateTime) {
    final now = DateTime.now();

    // Allow join 10 minutes before to 30 minutes after
    final startTime = appointmentDateTime.subtract(Duration(minutes: 10));
    final endTime = appointmentDateTime.add(Duration(minutes: 30));

    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool _isExpired(DateTime appointmentDateTime) {
    final now = DateTime.now();
    final endTime = appointmentDateTime.add(Duration(minutes: 30));

    return now.isAfter(endTime);
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

  void _processApiResponse(Map<String, dynamic> response) {
    Map<String, List<Map<String, dynamic>>> processedAppointments = {};

    if (response["data"] != null && response["data"] is List) {
      for (var dateGroup in response["data"]) {
        String dateKey = dateGroup["_id"];

        if (dateGroup["appointments"] != null &&
            dateGroup["appointments"] is List) {
          List<Map<String, dynamic>> appointmentsForDate = [];

          for (var appointment in dateGroup["appointments"]) {
            Map<String, dynamic> processedAppointment = {
              "id": appointment["_id"],
              "doctor": appointment["doctor"]["fullName"] ?? "Doctor",
              "specialty":
                  appointment["doctor"]["specialization"] ?? "Specialist",
              "time": _formatTime(appointment["appointmentTime"]),
              "status": "Confirmed",
              "type": "Consultation",
              "image": _getDoctorImage(appointment["doctor"]["profile_photo"]),
              "appointmentDate": _parseApiDate(appointment["appointmentDate"]),
              "appointmentDateTime": _combineDateTime(
                appointment["appointmentDate"],
                appointment["appointmentTime"],
              ),
              // "rawAppointment": appointment,
              "rawAppointment": {
                ...appointment,
                "appointmentDateTime": _combineDateTime(
                  appointment["appointmentDate"],
                  appointment["appointmentTime"],
                ),
              },
            };
            appointmentsForDate.add(processedAppointment);
          }

          // Convert date key to YYYY-MM-DD format for calendar
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

  DateTime _combineDateTime(String date, String time) {
    try {
      final parsedDate = DateTime.parse(date); // 2025-11-04
      final timeParts = time.split(":");

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      return DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        hour,
        minute,
      );
    } catch (e) {
      print("DateTime combine error: $e");
      return DateTime.now(); // fallback (safe)
    }
  }

  String _formatTime(String time) {
    try {
      // Handle time format (e.g., "10:16" -> "10:16 AM")
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
      return AppImages.d1;
    }

    // If it's a full URL, use it directly
    if (profilePhoto.startsWith('http')) {
      return profilePhoto;
    }

    // If it's just a filename, construct the full URL
    return "https://doctor-appointment-booking-backend-9iif.onrender.com/doctor/$profilePhoto";
  }

  String _parseApiDate(String apiDate) {
    try {
      // Convert "2025-11-04T00:00:00.000Z" to "2025-11-04"
      DateTime date = DateTime.parse(apiDate);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return apiDate;
    }
  }

  String _convertToYMD(String ddMMyyyy) {
    try {
      // Convert "04-11-2025" to "2025-11-04"
      List<String> parts = ddMMyyyy.split('-');
      if (parts.length == 3) {
        String day = parts[0];
        String month = parts[1];
        String year = parts[2];
        return "$year-$month-$day";
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
    required Map<String, dynamic> appt,
  }) {
    DateTime dt = appt["appointmentDateTime"];
    bool canJoin = _canJoinCall(dt);
    bool isExpired = _isExpired(dt);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
          /// Top Row
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: image.startsWith("http")
                    ? NetworkImage(image) as ImageProvider
                    : image.startsWith("assets/")
                    ? AssetImage(image)
                    : AssetImage("assets/images/default_doctor.png"),
                // backgroundImage: NetworkImage(appt["image"]),
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
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (status == "Confirmed")
                AppButton(
                  // onPressed: onJoin,
                  onPressed: canJoin
                      ? onJoin
                      : () {
                          if (isExpired) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Appointment time finished"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "You can join only at appointment time",
                                ),
                              ),
                            );
                          }
                        },
                  text: "Join Call",
                  textStyle: TextStyle(color: Colors.white, fontSize: 12),
                ),
            ],
          ),
          SizedBox(height: 12),

          /// Bottom Row
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
                  status,
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
                    onPressed: onReschedule,
                    child: Text(
                      "Reschedule",
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: onCancel,
                    child: Text(
                      "Cancel",
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
    if (_selectedDay == null) {
      return Center(child: Text("No date selected"));
    }
    List<Map<String, dynamic>> selectedAppointments = _getAppointmentsForDay(
      _selectedDay!,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          /// Title
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

          /// Calendar
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
                            color: Colors.red, // badge color
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

          /// Selected Date Header
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

          /// No Appointment Message
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

                    return appointmentCard(
                      doctorName: appt["doctor"] ?? "Doctor",
                      specialty: appt["specialty"] ?? "Specialist",
                      time: appt["time"] ?? "Time not set",
                      status: appt["status"] ?? "Confirmed",
                      type: appt["type"] ?? "Consultation",
                      image:
                          appt["image"] ?? "assets/images/default_doctor.png",
                      onJoin: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConsultScreen(
                              doctorName: appt["doctor"],
                              specialty: appt["specialty"],
                              hospital: appt["hospital"] ?? "Hospital",
                              location:
                                  appt["location"] ?? "Ahmedabad, Gujarat",
                              appointmentTime:
                                  appt["appointmentDateTime"] ?? DateTime.now(),
                              image: appt["image"] ?? "",
                              appointmentId: '',
                              patientId: '',
                            ),
                            // builder: (_) => DashBoardNew(2, false, false),
                          ),
                        );
                      },
                      onReschedule: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Reschedule functionality coming soon",
                            ),
                          ),
                        );
                      },
                      onCancel: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Cancel functionality coming soon"),
                          ),
                        );
                      },
                      rawAppointment: appt["rawAppointment"] ?? {},
                      appt: {},
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
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
