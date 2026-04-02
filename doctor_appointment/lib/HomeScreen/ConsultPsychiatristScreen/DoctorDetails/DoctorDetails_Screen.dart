import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/HomeScreen/ConsultPsychiatristScreen/DoctorBook/DoctorBook_Screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String doctorId;
  final Map<String, dynamic>? preloadedData;

  const DoctorDetailScreen({
    super.key,
    required this.doctorId,
    this.preloadedData,
  });

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  bool isLoading = false;
  Map<String, dynamic>? doctorDetail;
  DateTime? _selectedDate;
  String? _selectedTime;
  String? _selectedConsultType;
  String? _selectedSlotId; // Store the selected slot ID
  List<Map<String, dynamic>> availabilities = [];
  List<Map<String, dynamic>> alternativeDoctors = [];
  bool showBookedMessage = false;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) {
      _setPreloadedDoctor(widget.preloadedData!);
    } else {
      callDoctorDetailApi();
    }
  }

  void _setPreloadedDoctor(Map<String, dynamic> doc) {
    doctorDetail = {
      "_id": doc["_id"]?.toString() ?? "",
      "name": doc["fullName"] ?? doc["name"] ?? "Doctor",
      "speciality":
          doc["specializationName"] ?? doc["specialization"] ?? "Specialist",
      "location":
          (doc["addresses"] != null &&
              doc["addresses"] is List &&
              doc["addresses"].isNotEmpty)
          ? "${doc["addresses"][0]["city"]}, ${doc["addresses"][0]["state"]}"
          : "Ahmedabad, India",
      "about": doc["about"] ?? "",
      "experience": doc["experience"]?.toString() ?? "0",
      "image": doc["profile_photo"] ?? "",
      "chatFee": doc["chatFee"] ?? 200,
      "audioFee": doc["voiceCallFee"] ?? 300,
      "videoFee": doc["videoCallFee"] ?? 600,
      "languages": (doc["languages"] is List)
          ? List<String>.from(doc["languages"].map((e) => e.toString()))
          : ["English"],
      "clinicAddressId":
          (doc["addresses"] != null &&
              doc["addresses"] is List &&
              doc["addresses"].isNotEmpty)
          ? doc["addresses"][0]["_id"]
          : "68bad62466b24b65c0ac9180",
    };

    if (doc["availabilities"] != null && doc["availabilities"] is List) {
      availabilities = (doc["availabilities"] as List)
          .map<Map<String, dynamic>>((a) {
            List<Map<String, dynamic>> slotList = [];
            for (var s in a["slots"]) {
              slotList.add({
                // "time": s["time"].toString(),
                "startTime": s["startTime"] ?? s["time"],
                "endTime": s["endTime"] ?? "",
                "isBooked": s["isBooked"] ?? false,
                "alternativeDoctor": s["alternativeDoctor"],
                "slotId": s["_id"], // Store the slot ID
              });
            }
            return {
              "date": DateTime.parse(a["date"].toString()),
              "slots": slotList,
              "availabilityId": a["_id"], // Store availability ID
            };
          })
          .toList();
    }

    setState(() {});
  }

  Future<void> callDoctorDetailApi() async {
    setState(() => isLoading = true);
    try {
      ApiService apiService = ApiService();
      var response = await apiService.callGetDoctorById(widget.doctorId);

      if (response != null && response["success"] == true) {
        final doc = (response["data"] is List && response["data"].isNotEmpty)
            ? response["data"][0]
            : response["data"];
        _setPreloadedDoctor(doc);
      }
    } catch (e) {
      print("❌ Error fetching doctor details: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Doctor Details",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: AppColor.colorPrimary,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.white),

        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctorDetail == null
          ? const Center(child: Text("Doctor details not found"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 25),
                  _buildSectionTitle("About"),
                  const SizedBox(height: 6),
                  Text(
                    doctorDetail!["about"].isEmpty
                        ? "No description available."
                        : doctorDetail!["about"],
                    style: const TextStyle(
                      color: Colors.black87,
                      height: 1.4,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Languages"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: (doctorDetail!["languages"] as List)
                        .map(
                          (lang) => Chip(
                            label: Text(lang),
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Available Slots"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: _selectDateFromApi,
                          icon: Icons.calendar_month_rounded,
                          iconPosition: IconPosition.left,
                          iconColor: AppColor.colorPrimary,
                          backgroundColor: AppColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColor.colorPrimary),
                          ),
                          text: _selectedDate == null
                              ? "Select Date"
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          textStyle: TextStyle(
                            color: AppColor.colorPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          onPressed: _selectedDate != null
                              ? _selectTimeFromApi
                              : null,
                          icon: Icons.access_time_outlined,
                          iconPosition: IconPosition.left,
                          iconColor: AppColor.colorPrimary,
                          backgroundColor: AppColor.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColor.colorPrimary),
                          ),
                          text: _selectedTime ?? "Select Time",

                          textStyle: TextStyle(
                            color: AppColor.colorPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (showBookedMessage)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "This time slot is not available. Another doctor is suggested below.",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 13.5,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (alternativeDoctors.isNotEmpty) ...[
                    _buildSectionTitle("Alternative Doctors"),
                    const SizedBox(height: 10),
                    _buildAlternativeDoctorSlider(),
                    const SizedBox(height: 20),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed:
                          (_selectedDate != null &&
                              _selectedTime != null &&
                              _selectedConsultType != null &&
                              alternativeDoctors.isEmpty)
                          ? () {
                              // Find the selected availability
                              final selectedAvail = availabilities.firstWhere(
                                (a) => a["date"] == _selectedDate,
                                orElse: () => {},
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DoctorBookAppointmentScreen(
                                    doctor: doctorDetail!,
                                    selectedDate:
                                        "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                    selectedTime: _selectedTime!,
                                    selectedConsultType: _selectedConsultType!,
                                    // ✅ Pass the correct slotId (availability ID)
                                    slotId:
                                        _selectedSlotId ??
                                        selectedAvail["availabilityId"],
                                  ),
                                ),
                              );
                            }
                          : null,
                      text: alternativeDoctors.isNotEmpty
                          ? "Slot Booked - Choose Alternative"
                          : "Book Appointment",
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage:
              (doctorDetail!["image"] != null &&
                  doctorDetail!["image"].toString().isNotEmpty)
              ? NetworkImage(doctorDetail!["image"])
              : const AssetImage("assets/images/default_doctor.png")
                    as ImageProvider,
        ),
        const SizedBox(height: 12),
        Text(
          "Dr. ${doctorDetail!["name"]}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          doctorDetail!["speciality"],
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          "${doctorDetail!["experience"]} years experience • ${doctorDetail!["location"]}",
          style: const TextStyle(color: Colors.black45, fontSize: 13.5),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _consultOption(
                "Chat",
                Icons.chat_outlined,
                "chat",
                doctorDetail!["chatFee"],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _consultOption(
                "Audio",
                Icons.call_outlined,
                "audio",
                doctorDetail!["audioFee"],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _consultOption(
          "Video",
          Icons.videocam_outlined,
          "video",
          doctorDetail!["videoFee"],
        ),
      ],
    );
  }

  Widget _consultOption(String label, IconData icon, String type, dynamic fee) {
    final selected = _selectedConsultType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedConsultType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColor.colorIntroBG.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColor.colorIntroBG : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: selected ? AppColor.colorIntroBG : Colors.black87,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColor.colorIntroBG : Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              "₹$fee",
              style: TextStyle(
                color: selected ? AppColor.colorIntroBG : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  void _selectDateFromApi() {
    if (availabilities.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔹 HEADER (ONLY ONCE)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Date",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColor.colorPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 10),

              /// 🔹 DATE LIST
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availabilities.length,
                  itemBuilder: (context, index) {
                    final a = availabilities[index];
                    final date = a["date"] as DateTime;

                    final formatted = "${date.day}/${date.month}/${date.year}";

                    final isSelected =
                        _selectedDate != null &&
                        _selectedDate!.year == date.year &&
                        _selectedDate!.month == date.month &&
                        _selectedDate!.day == date.day;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          _selectedTime = null;
                          _selectedSlotId = null;
                          alternativeDoctors.clear();
                          showBookedMessage = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColor.colorIntroBG.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColor.colorIntroBG
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatted,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? AppColor.colorIntroBG
                                    : Colors.black87,
                              ),
                            ),

                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppColor.colorIntroBG,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectTimeFromApi() {
    final selectedAvail = availabilities.firstWhere(
      (a) => a["date"] == _selectedDate,
      orElse: () => {},
    );

    final availabilityId = selectedAvail["availabilityId"];
    final slots = selectedAvail["slots"] ?? [];

    // ✅ SORT BY TIME
    slots.sort((a, b) {
      String timeA = a["startTime"] ?? "";
      String timeB = b["startTime"] ?? "";

      DateTime parsedA = _parseTime(timeA);
      DateTime parsedB = _parseTime(timeB);

      return parsedA.compareTo(parsedB);
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Time Slot",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColor.colorPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(slots.length, (index) {
                    final slot = slots[index];

                    final start = slot["startTime"];
                    final end = slot["endTime"];
                    final isBooked = slot["isBooked"];

                    final displayTime = end != null && end != ""
                        ? "$start - $end"
                        : start;

                    final isSelected = _selectedTime == displayTime;

                    return GestureDetector(
                      onTap: isBooked
                          ? null
                          : () {
                              Navigator.pop(context);

                              setState(() {
                                _selectedTime = displayTime;
                                // _selectedSlotId = availabilityId;
                                _selectedSlotId = slot["slotId"];
                                if (slot["isBooked"] == true &&
                                    slot["alternativeDoctor"] != null) {
                                  final altDoc = slot["alternativeDoctor"];
                                  showBookedMessage = true;

                                  alternativeDoctors = [
                                    {
                                      "_id": altDoc["_id"] ?? "",
                                      "name":
                                          altDoc["fullName"] ??
                                          altDoc["name"] ??
                                          "Doctor",
                                      "photo": altDoc["profile_photo"] ?? "",
                                      "avgRating": altDoc["avgRating"] ?? 0,
                                      "totalReviews":
                                          altDoc["totalReviews"] ?? 0,
                                      "specialization":
                                          doctorDetail?["speciality"] ??
                                          "Specialist",
                                      "availabilities":
                                          altDoc["availabilities"] ?? [],
                                      "chatFee": altDoc["chatFee"] ?? 200,
                                      "audioFee": altDoc["voiceCallFee"] ?? 300,
                                      "videoFee": altDoc["videoCallFee"] ?? 600,
                                    },
                                  ];
                                } else {
                                  showBookedMessage = false;
                                  alternativeDoctors.clear();
                                }
                              });
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isBooked
                              ? Colors.grey.shade200
                              : isSelected
                              ? AppColor.colorIntroBG
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColor.colorIntroBG
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          displayTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: isBooked
                                ? Colors.grey
                                : isSelected
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _parseTime(String time) {
    try {
      final parts = time.split(":");
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      return DateTime(0, 0, 0, hour, minute);
    } catch (e) {
      return DateTime(0);
    }
  }

  Widget _buildAlternativeDoctorSlider() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: alternativeDoctors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final doc = alternativeDoctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailScreen(
                    doctorId: doc["_id"] ?? "",
                    preloadedData: doc,
                  ),
                ),
              );
            },
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        (doc["photo"] != null &&
                            doc["photo"].toString().isNotEmpty)
                        ? NetworkImage(doc["photo"])
                        : const AssetImage("assets/images/default_doctor.png")
                              as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doc["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    doc["specialization"] ?? "Specialist",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amberAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${doc["avgRating"] ?? 0} (${doc["totalReviews"] ?? 0})",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
