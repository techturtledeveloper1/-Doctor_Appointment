import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String hospital;
  final String location;
  final String date;
  final String time;
  final String image;

  const AppointmentDetailScreen({
    Key? key,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.location,
    required this.date,
    required this.time,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: image.startsWith("assets/")
                  ? AssetImage(image)
                  : NetworkImage(image) as ImageProvider,
            ),
            SizedBox(height: 12),
            Text(
              doctorName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Text(
              specialty,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              "$hospital • $location",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),

            /// Appointment Date & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.black54),
                SizedBox(width: 6),
                Text(date, style: TextStyle(fontSize: 16)),
                SizedBox(width: 20),
                Icon(Icons.access_time, size: 18, color: Colors.black54),
                SizedBox(width: 6),
                Text(time, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 25),

            /// Buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text("Join Video Call", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text("Join Audio Call"),
            ),
            SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text("Open Chat"),
            ),
            SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.upload_file, size: 18),
              label: Text("Upload Prescription or Notes"),
            ),

            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),

            /// Reschedule & Cancel
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Reschedule Appointment")));
              },
              child: Text("Reschedule Appointment",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Cancel Appointment")));
              },
              child: Text("Cancel Appointment",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent)),
            ),
            SizedBox(height: 20),

            Text(
              "You will receive a reminder 15 minutes before your session.",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
