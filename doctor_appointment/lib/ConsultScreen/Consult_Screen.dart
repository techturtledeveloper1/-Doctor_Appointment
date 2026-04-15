import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doctor_appointment/HomeScreen/ChatScreen/Chat_Screen.dart';
import 'package:doctor_appointment/HomeScreen/ChatScreen/VideoCall_Screen.dart';
import 'package:doctor_appointment/HomeScreen/ChatScreen/VoiceCall_Screen.dart';
import 'package:doctor_appointment/Notification/call_notification.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConsultScreen extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String hospital;
  final String location;
  final DateTime appointmentTime;
  final String image;
  final String appointmentId;
  final String patientId;
  final String status;
  final String appointmentType;

  const ConsultScreen({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.location,
    required this.appointmentTime,
    required this.image,
    required this.appointmentId,
    required this.patientId,
    required this.status,
    required this.appointmentType,
  });

  @override
  State<ConsultScreen> createState() => _ConsultScreenState();
}

class _ConsultScreenState extends State<ConsultScreen> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;
  File? selectedFile;
  PatientCallListener? _callListener;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeLeft();
    });

    // Start listening for incoming calls
    _callListener = PatientCallListener();
    _callListener!.startListening(widget.patientId, context);

    print("📅 ConsultScreen Initialized:");
    print("Patient ID for call listening: ${widget.patientId}");
    print("📅 ConsultScreen Initialized:");
    print("Doctor: ${widget.doctorName}");
    print("Appointment Time: ${widget.appointmentTime}");
    print("Appointment ID: ${widget.appointmentId}");
    print("Patient ID: ${widget.patientId}");
    print("Appointment Time: ${widget.appointmentTime}");
    print(
      "Appointment Time (ISO): ${widget.appointmentTime.toIso8601String()}",
    );
    print("Current Time: ${DateTime.now()}");
    print("Current Time (ISO): ${DateTime.now().toIso8601String()}");
    final difference = widget.appointmentTime.difference(DateTime.now());
    print("Time difference: ${difference.inMinutes} minutes");
  }

  bool get isCancelled => widget.status.toLowerCase() == "cancelled";
  bool get isPending => widget.status.toLowerCase() == "pending";
  bool get isConfirmed => widget.status.toLowerCase() == "confirmed";

  void _updateTimeLeft() {
    final now = DateTime.now();
    setState(() {
      // Allow joining 5 minutes before appointment time
      final joinTime = widget.appointmentTime.subtract(
        const Duration(minutes: 5),
      );
      _timeLeft = joinTime.difference(now);
      if (_timeLeft.isNegative) _timeLeft = Duration.zero;
    });
  }

  bool get canJoin {
    final now = DateTime.now();
    final joinTime = widget.appointmentTime.subtract(
      const Duration(minutes: 5),
    );
    final endTime = widget.appointmentTime.add(const Duration(minutes: 30));

    // Can join between 5 minutes before and 30 minutes after appointment
    return now.isAfter(joinTime) && now.isBefore(endTime);
  }

  bool get isExpired {
    final now = DateTime.now();
    final endTime = widget.appointmentTime.add(const Duration(minutes: 30));
    return now.isAfter(endTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _callListener?.stopListening();

    super.dispose();
  }

  String get _formattedCountdown {
    if (_timeLeft.inDays > 0) {
      return "${_timeLeft.inDays}d ${_timeLeft.inHours.remainder(24)}h";
    } else if (_timeLeft.inHours > 0) {
      final hours = _timeLeft.inHours;
      final minutes = _timeLeft.inMinutes.remainder(60);
      return "$hours ${minutes}m";
    } else {
      final minutes = _timeLeft.inMinutes.remainder(60);
      final seconds = _timeLeft.inSeconds.remainder(60);
      return "$minutes:${seconds.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedFile = File(picked.path);
      });
      _uploadFile();
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        selectedFile = File(picked.path);
      });
      _uploadFile();
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
      _uploadFile();
    }
  }

  Future<void> _uploadFile() async {
    // TODO: Implement file upload to server
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Uploading ${selectedFile?.path.split('/').last}..."),
      ),
    );

    // Simulate upload
    await Future.delayed(Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("File uploaded successfully!")),
    );
  }

  void showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromCamera();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColor.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.camera_alt, size: 30),
                            SizedBox(height: 8),
                            Text("Take Photo"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickFile();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColor.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.image, size: 30),
                            SizedBox(height: 8),
                            Text("Gallery"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _pickPdf();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColor.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.picture_as_pdf, size: 30),
                            SizedBox(height: 8),
                            Text("PDF"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> startVideoCall(BuildContext context) async {
    // Check internet connection
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No Internet Connection")));
      return;
    }

    // Request permissions
    var cameraStatus = await Permission.camera.request();
    var micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoCallPage(
            // userId: "patient_1",
            // userName: "Pooja",
            // callId: "appointment_101",
            // userId: widget.patientId,
            userId: widget.patientId.isNotEmpty
                ? widget.patientId
                : "patient_${DateTime.now().millisecondsSinceEpoch}",
            userName: widget.doctorName,
            callId: widget.appointmentId,
            endTime: widget.appointmentTime.add(const Duration(minutes: 30)),
            doctorName: widget.doctorName,
            doctorImage: widget.image,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Camera & Microphone permission required for video call",
          ),
        ),
      );
    }
  }

  void startAudioCall(BuildContext context) async {
    // Check internet connection
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No Internet Connection")));
      return;
    }

    // Request microphone permission only
    var micStatus = await Permission.microphone.request();

    if (micStatus.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VoiceCallPage(
            userId: widget.patientId,
            userName: widget.doctorName,
            callId: widget.appointmentId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Microphone permission required for audio call"),
        ),
      );
    }
  }

  void showTermsDialog(BuildContext context, {required bool isVideoCall}) {
    bool isChecked = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text(
                "Terms & Conditions",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Before starting the video consultation:\n\n"
                      "• Do not share personal or sensitive information.\n"
                      "• This consultation is for general guidance only.\n"
                      "• In case of emergency, contact a hospital immediately.\n"
                      "• Please ensure proper lighting and internet connection.\n"
                      "• Keep your camera and microphone ready.\n"
                      "• Prescription is at doctor's discretion.\n"
                      "• Follow doctor's advice responsibly.\n"
                      "• The call may be recorded for quality purposes.\n",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.colorPrimary,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "I agree to Terms & Conditions",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: () => Navigator.pop(context),
                        text: "Cancel",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        onPressed: isChecked
                            ? () {
                                Navigator.pop(context);
                                if (isVideoCall) {
                                  startVideoCall(context);
                                } else {
                                  startAudioCall(context);
                                }
                              }
                            : null,
                        // onPressed: isChecked
                        //     ? () {
                        //         Navigator.pop(context);
                        //         startVideoCall(context);
                        //       }
                        //     : null,
                        text: "Accept",
                        backgroundColor: isChecked
                            ? AppColor.colorPrimary
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text("Consultation"),
        backgroundColor: AppColor.colorIntroBG,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: widget.image.isNotEmpty
                  ? (widget.image.startsWith("http")
                            ? NetworkImage(widget.image)
                            : AssetImage(widget.image))
                        as ImageProvider
                  : AssetImage(AppImages.d2),
            ),
            const SizedBox(height: 12),
            Text(
              widget.doctorName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.colorIntroBG,
              ),
            ),
            Text(
              widget.specialty,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              "${widget.hospital} • ${widget.location}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            /// Appointment Date & Time
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.colorIntroBG.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColor.colorIntroBG,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd MMM yyyy').format(widget.appointmentTime),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.colorIntroBG,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: AppColor.colorIntroBG,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('hh:mm a').format(widget.appointmentTime),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.colorIntroBG,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            /// Countdown or Expired Message
            if (!canJoin && !isExpired)
              Column(
                children: [
                  Text(
                    "Join available in",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.colorIntroBG,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _formattedCountdown,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your consultation will start at ${DateFormat('hh:mm a').format(widget.appointmentTime)}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            if (isCancelled) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.cancel, size: 50, color: Colors.red),
                    SizedBox(height: 10),
                    Text(
                      "Appointment Cancelled",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "This appointment has been cancelled",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ] else if (isExpired) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.timer_off, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "Consultation Expired",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "This consultation time has passed",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],

            /// Action Buttons
            if (canJoin) ...[
              if (widget.appointmentType.toLowerCase() == "video")
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorIntroBG,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showTermsDialog(context, isVideoCall: true);
                  },
                  child: const Text(
                    "Join Video Call",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              // const SizedBox(height: 12),
              if (widget.appointmentType.toLowerCase() == "phone")
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    startAudioCall(context);
                    // showTermsDialog(context, isVideoCall: false);
                  },
                  child: Text(
                    "Join Audio Call",
                    style: TextStyle(color: AppColor.colorIntroBG),
                  ),
                ),
              if (widget.appointmentType.toLowerCase() == "chat")
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          // myId: widget.patientId,
                          myId: widget.patientId.isNotEmpty
                              ? widget.patientId
                              : "patient_${DateTime.now().millisecondsSinceEpoch}",
                          myName: "Patient",
                          peerId: "doctor_${widget.appointmentId}",
                          peerName: widget.doctorName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Open Chat",
                    style: TextStyle(color: AppColor.colorIntroBG),
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  showUploadOptions();
                },
                icon: const Icon(Icons.upload_file, size: 18),
                label: Text(
                  "Upload Prescription or Notes",
                  style: TextStyle(color: AppColor.colorIntroBG),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              /// Reschedule & Cancel
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Reschedule functionality coming soon"),
                    ),
                  );
                },
                child: const Text(
                  "Reschedule Appointment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  _showCancelDialog();
                },
                child: const Text(
                  "Cancel Appointment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You will receive a reminder 15 minutes before your session.",
                        style: TextStyle(fontSize: 13, color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancel Appointment"),
        content: Text(
          "Are you sure you want to cancel your appointment with ${widget.doctorName}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement cancel API call
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Appointment cancelled")));
              Navigator.pop(context); // Go back to calendar
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Yes, Cancel"),
          ),
        ],
      ),
    );
  }
}

// class ConsultScreen extends StatefulWidget {
//   final String doctorName;
//   final String specialty;
//   final String hospital;
//   final String location;
//   final DateTime appointmentTime;
//   final String image;
//   final String appointmentId;
//   final String patientId;
//
//   const ConsultScreen({
//     super.key,
//     required this.doctorName,
//     required this.specialty,
//     required this.hospital,
//     required this.location,
//     required this.appointmentTime,
//     required this.image,
//     required this.appointmentId,
//     required this.patientId,
//   });
//
//   @override
//   State<ConsultScreen> createState() => _ConsultScreenState();
// }
//
// class _ConsultScreenState extends State<ConsultScreen> {
//   Timer? _timer;
//   Duration _timeLeft = Duration.zero;
//   File? selectedFile;
//
//   Future<void> _pickFile() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//
//     if (picked != null) {
//       setState(() {
//         selectedFile = File(picked.path);
//       });
//
//       // uploadPrescription(widget.appointmentId);
//     }
//   }
//
//   Future<void> _pickFromCamera() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.camera);
//
//     if (picked != null) {
//       setState(() {
//         selectedFile = File(picked.path);
//       });
//     }
//   }
//
//   Future<void> _pickPdf() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//
//     if (result != null) {
//       setState(() {
//         selectedFile = File(result.files.single.path!);
//       });
//       // uploadPrescription(widget.appointmentId);
//     }
//   }
//
//   void showUploadOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColor.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Wrap(
//             children: [
//               /// Title
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade400,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               Row(
//                 children: [
//                   /// Camera
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                         _pickFromCamera();
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 20),
//                         decoration: BoxDecoration(
//                           color: AppColor.grey.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Icon(Icons.camera_alt, size: 30),
//                             SizedBox(height: 8),
//                             Text("Take Photo"),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   /// Gallery
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                         // _pickFromGallery();
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 20),
//                         decoration: BoxDecoration(
//                           color: AppColor.grey.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Icon(Icons.image, size: 30),
//                             SizedBox(height: 8),
//                             Text("Gallery"),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _updateTimeLeft();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _updateTimeLeft();
//     });
//   }
//
//   void _updateTimeLeft() {
//     final now = DateTime.now();
//     setState(() {
//       _timeLeft = widget.appointmentTime.difference(now);
//       if (_timeLeft.isNegative) _timeLeft = Duration.zero;
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   String get _formattedCountdown {
//     final hours = _timeLeft.inHours.remainder(24).toString().padLeft(2, '0');
//     final minutes = _timeLeft.inMinutes
//         .remainder(60)
//         .toString()
//         .padLeft(2, '0');
//     final seconds = _timeLeft.inSeconds
//         .remainder(60)
//         .toString()
//         .padLeft(2, '0');
//     return hours != "00" ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final canJoin = _timeLeft <= Duration.zero;
//
//     return Scaffold(
//       backgroundColor: AppColor.white,
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 45,
//               // backgroundImage: AssetImage(AppImages.d2),
//               // : NetworkImage("audio/Images/d1.png") as ImageProvider,
//               backgroundImage: widget.image.isNotEmpty
//                   ? (widget.image.startsWith("http")
//                             ? NetworkImage(widget.image)
//                             : AssetImage(widget.image))
//                         as ImageProvider
//                   : AssetImage(AppImages.d2),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               widget.doctorName,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColor.colorIntroBG,
//               ),
//             ),
//             Text(
//               widget.specialty,
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             Text(
//               "${widget.hospital} • ${widget.location}",
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 20),
//
//             /// Appointment Date & Time
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   size: 18,
//                   color: AppColor.colorIntroBG,
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   DateFormat('dd MMM yyyy').format(widget.appointmentTime),
//                   style: TextStyle(fontSize: 16, color: AppColor.colorIntroBG),
//                 ),
//                 const SizedBox(width: 20),
//                 Icon(Icons.access_time, size: 18, color: AppColor.colorIntroBG),
//                 const SizedBox(width: 6),
//                 Text(
//                   DateFormat('hh:mm a').format(widget.appointmentTime),
//                   style: TextStyle(fontSize: 16, color: AppColor.colorIntroBG),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),
//
//             /// Countdown
//             if (!canJoin)
//               Column(
//                 children: [
//                   Text(
//                     "Join available in",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: AppColor.colorIntroBG,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.red[50],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       _formattedCountdown,
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//
//             /// Action Buttons
//             if (canJoin) ...[
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.colorIntroBG,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {
//                   // // Navigator.push(
//                   // //   context,
//                   // //   MaterialPageRoute(
//                   // //     builder: (_) => VideoCallScreen(
//                   // //       doctorName: widget.doctorName,
//                   // //       specialty: widget.specialty,
//                   // //     ),
//                   // //   ),
//                   // // );
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (_) => VideoCallPage(
//                   //       userId: "patient_1",
//                   //       userName: "Pooja",
//                   //       callId: "appointment_101",
//                   //     ),
//                   //   ),
//                   // );
//                   showTermsDialog(context);
//                 },
//                 child: Text(
//                   "Join Video Call",
//                   style: TextStyle(color: AppColor.white),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   const SnackBar(content: Text("Joining Audio Call...")),
//                   // );
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => VoiceCallPage(
//                         userId: "patient_2",
//                         userName: "Patient",
//                         callId: "appointment_123", // SAME ID
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "Join Audio Call",
//                   style: TextStyle(color: AppColor.colorIntroBG),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatScreen(
//                         myId: "patient_1",
//                         myName: "Pooja Khandhala",
//                         peerId: "doctor_2",
//                         peerName: widget.doctorName,
//                         // userId: "patient_2",
//                         // userName: "Pooja",
//                         // chatId: "appointment_123",
//                       ),
//                     ),
//                   );
//                 },
//                 // onPressed: () {
//                 //   Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //       builder: (_) => ChatScreen(doctorName: widget.doctorName),
//                 //     ),
//                 //   );
//                 // },
//                 child: Text(
//                   "Open Chat",
//                   style: TextStyle(color: AppColor.colorIntroBG),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {
//                   // _pickFile();
//                   showUploadOptions();
//                 },
//                 icon: const Icon(Icons.upload_file, size: 18),
//                 label: Text(
//                   "Upload Prescription or Notes",
//                   style: TextStyle(color: AppColor.colorIntroBG),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Divider(),
//               const SizedBox(height: 10),
//
//               /// Reschedule & Cancel
//               GestureDetector(
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Reschedule Appointment clicked"),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   "Reschedule Appointment",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               GestureDetector(
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Cancel Appointment clicked")),
//                   );
//                 },
//                 child: const Text(
//                   "Cancel Appointment",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.redAccent,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "You will receive a reminder 15 minutes before your session.",
//                 style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showTermsDialog(BuildContext context) {
//     bool isChecked = false;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//
//               title: Text(
//                 "Terms & Conditions",
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               content: Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Before starting the video consultation:\n\n"
//                         "• Do not share personal or sensitive information.\n"
//                         "• This consultation is for general guidance only.\n"
//                         "• In case of emergency, contact a hospital immediately.\n"
//                         "• Please ensure proper lighting and internet connection.\n"
//                         "• Keep your camera and microphone ready.\n"
//                         "• Prescription is at doctor's discretion.\n"
//                         "• Follow doctor's advice responsibly.\n"
//                         "• The call may be recorded for quality purposes.\n",
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       ),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Checkbox(
//                             activeColor: AppColor.colorPrimary,
//                             value: isChecked,
//                             onChanged: (value) {
//                               setState(() {
//                                 isChecked = value!;
//                               });
//                             },
//                           ),
//                           const Expanded(
//                             child: Text(
//                               "I agree to Terms & Conditions",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: AppButton(
//                         onPressed: () => Navigator.pop(context),
//                         text: "Cancel",
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: AppButton(
//                         onPressed: isChecked
//                             ? () {
//                                 Navigator.pop(context);
//                                 startVideoCall(context);
//                               }
//                             : null,
//                         text: "Accept",
//                         backgroundColor: isChecked
//                             ? AppColor.colorPrimary
//                             : Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> startVideoCall(BuildContext context) async {
//     // showDialog(
//     //   context: context,
//     //   barrierDismissible: false,
//     //   builder: (_) => const Center(child: CircularProgressIndicator()),
//     // );
//     //
//     // /// Internet Check
//     // var connectivity = await Connectivity().checkConnectivity();
//     // if (connectivity == ConnectivityResult.none) {
//     //   Navigator.pop(context);
//     //   ScaffoldMessenger.of(
//     //     context,
//     //   ).showSnackBar(const SnackBar(content: Text("No Internet Connection")));
//     //   return;
//     // }
//     //
//     // /// Permission Check
//     // await Permission.camera.request();
//     // await Permission.microphone.request();
//     //
//     // await Future.delayed(const Duration(seconds: 1));
//     //
//     // Navigator.pop(context);
//     var cameraStatus = await Permission.camera.request();
//     var micStatus = await Permission.microphone.request();
//     if (cameraStatus.isGranted && micStatus.isGranted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => VideoCallPage(
//             userId: "patient_1",
//             userName: "Pooja",
//             callId: "appointment_101",
//             endTime: widget.appointmentTime.add(const Duration(minutes: 30)),
//             // callId:
//             //     "appointment_${widget.appointmentTime.millisecondsSinceEpoch}",
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Camera & Microphone permission required"),
//         ),
//       );
//     }
//   }
// }
