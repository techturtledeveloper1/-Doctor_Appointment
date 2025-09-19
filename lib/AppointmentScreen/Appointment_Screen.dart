import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../HomeScreen/TalkDoctor/Speiality_Screen.dart';
import '../Utils/ColorConstant.dart';
import '../../DashBoard/DashBoard.dart';

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

  Map<String, List<Map<String, dynamic>>> appointmentsByDate = {
    "2025-09-06": [
      {
        "doctor": "Dr. Priya Shah",
        "specialty": "Gynecologist",
        "time": "10:30 AM",
        "type": "Video Call",
        "status": "Booked",
        "image": "assets/Images/d6.png"
      },
      {
        "doctor": "Dr. Rakesh Mehta",
        "specialty": "Psychiatrist",
        "time": "2:00 PM",
        "type": "In-Clinic",
        "status": "Pending",
        "image": "assets/Images/d1.png"
      }
    ],
    "2025-09-10": [
      {
        "doctor": "Dr. Neha Patel",
        "specialty": "Dermatologist",
        "time": "5:00 PM",
        "type": "Chat",
        "status": "Booked",
        "image": "assets/Images/d2.png"
      }
    ]
  };

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return appointmentsByDate[DateFormat('yyyy-MM-dd').format(day)] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // Update countdown every second
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {}); // rebuild to update countdown
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String getCountdown(DateTime appointmentTime) {
    final now = DateTime.now();
    final difference = appointmentTime.difference(now);
    if (difference.isNegative) return "00:00";
    final minutes = difference.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = difference.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedAppointments =
    _getAppointmentsForDay(_selectedDay!);

    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black87),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     "Appointments",
      //     style: TextStyle(
      //       color: ColorConstant.colorIntroBG,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Title Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Appointments",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.colorIntroBG),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline,
                        size: 28, color: ColorConstant.colorIntroBG),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SpecialityScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// Calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TableCalendar(
                firstDay: DateTime(2022),
                lastDay: DateTime(2026),
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
                  _focusedDay = focusedDay;
                },
                eventLoader: _getAppointmentsForDay,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: ColorConstant.colorIntroBG,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  markerDecoration: BoxDecoration(
                    color: ColorConstant.colorIntroBG,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon:
                  Icon(Icons.arrow_back_ios, color: ColorConstant.colorIntroBG),
                  rightChevronIcon:
                  Icon(Icons.arrow_forward_ios, color: ColorConstant.colorIntroBG),
                ),
              ),
            ),

            /// Appointments List
            if (selectedAppointments.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: selectedAppointments.length,
                itemBuilder: (context, index) {
                  var appointment = selectedAppointments[index];
                  DateTime appointmentDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(
                    "${DateFormat('yyyy-MM-dd').format(_selectedDay!)} ${appointment["time"]}",
                  );

                  // Show Join Call only within 5 minutes of appointment
                  bool canJoinCall = appointment["type"] == "Video Call" &&
                      appointment["status"] == "Booked" &&
                      DateTime.now().isAfter(
                        appointmentDateTime.subtract(Duration(minutes: 5)),
                      );

                  bool isBeforeCall = appointment["type"] == "Video Call" &&
                      appointment["status"] == "Booked" &&
                      DateTime.now().isBefore(
                        appointmentDateTime.subtract(Duration(minutes: 5)),
                      );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                    image: appointment["image"]
                                        .toString()
                                        .startsWith("assets/")
                                        ? AssetImage(appointment["image"]) as ImageProvider
                                        : NetworkImage(appointment["image"]),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment["doctor"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        appointment["specialty"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 16,
                                              color: ColorConstant.colorIntroBG),
                                          SizedBox(width: 6),
                                          Text(
                                            DateFormat('dd MMM yyyy')
                                                .format(_selectedDay!),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(width: 12),
                                          Icon(Icons.access_time,
                                              size: 16,
                                              color: ColorConstant.colorIntroBG),
                                          SizedBox(width: 6),
                                          Text(
                                            appointment["time"],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            appointment["status"] == "Booked"
                                                ? Icons.check_circle
                                                : Icons.hourglass_bottom,
                                            size: 16,
                                            color: appointment["status"] == "Booked"
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            appointment["status"] ?? "Pending",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: appointment["status"] == "Booked"
                                                  ? Colors.green
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            /// Countdown or Join Button
                            if (isBeforeCall)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Join call in ${getCountdown(appointmentDateTime)}",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (canJoinCall)
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorConstant.colorIntroBG,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: Icon(Icons.video_call, color: Colors.white),
                                  label: Text("Join Call",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DashBoardNew(2, false, false),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "No Appointments for this day",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
