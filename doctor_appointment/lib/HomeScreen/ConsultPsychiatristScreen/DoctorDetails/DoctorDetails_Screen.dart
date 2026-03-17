import 'package:flutter/material.dart';
import '../../../Utils/ColorConstant.dart';
import '../../../APIService/ApiService.dart';
import '../../TalkDoctor/DoctorBookAppointment/DoctorBookAppointment_Screen.dart';
import '../DoctorBook/DoctorBook_Screen.dart';

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
      "speciality": doc["specializationName"] ?? doc["specialization"] ?? "Specialist",
      "location": (doc["addresses"] != null &&
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
      "clinicAddressId": (doc["addresses"] != null &&
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
            "time": s["time"].toString(),
            "isBooked": s["isBooked"] ?? false,
            "alternativeDoctor": s["alternativeDoctor"],
            "slotId": s["_id"] // Store the slot ID
          });
        }
        return {
          "date": DateTime.parse(a["date"].toString()),
          "slots": slotList,
          "availabilityId": a["_id"] // Store availability ID
        };
      }).toList();
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
        title: const Text("Doctor Details"),
        backgroundColor: Colors.white,
        foregroundColor: ColorConstant.colorIntroBG,
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
                  color: Colors.black87, height: 1.4, fontSize: 14.5),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Languages"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (doctorDetail!["languages"] as List)
                  .map((lang) => Chip(
                label: Text(lang),
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Available Slots"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDateFromApi,
                    icon: const Icon(Icons.calendar_today_outlined,
                        size: 18),
                    label: Text(
                      _selectedDate == null
                          ? "Select Date"
                          : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorConstant.colorIntroBG),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                    _selectedDate != null ? _selectTimeFromApi : null,
                    icon: const Icon(Icons.access_time_outlined, size: 18),
                    label: Text(
                      _selectedTime ?? "Select Time",
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorConstant.colorIntroBG),
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
                  border:
                  Border.all(color: Colors.red.shade200, width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "This time slot is not available. Another doctor is suggested below.",
                        style: TextStyle(
                            color: Colors.red, fontSize: 13.5, height: 1.4),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: (_selectedDate != null &&
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
                        selectedDate: "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        selectedTime: _selectedTime!,
                        selectedConsultType: _selectedConsultType!,
                        // ✅ Pass the correct slotId (availability ID)
                        slotId: _selectedSlotId ?? selectedAvail["availabilityId"],
                      ),
                    ),
                  );
                }
                    : null,
                child: Text(
                  alternativeDoctors.isNotEmpty
                      ? "Slot Booked - Choose Alternative"
                      : "Book Appointment",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
          backgroundImage: (doctorDetail!["image"] != null &&
              doctorDetail!["image"].toString().isNotEmpty)
              ? NetworkImage(doctorDetail!["image"])
              : const AssetImage("assets/Images/default_doctor.png")
          as ImageProvider,
        ),
        const SizedBox(height: 12),
        Text(
          "Dr. ${doctorDetail!["name"]}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(doctorDetail!["speciality"],
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
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
                  "Chat", Icons.chat_outlined, "chat", doctorDetail!["chatFee"]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _consultOption(
                  "Audio", Icons.call_outlined, "audio", doctorDetail!["audioFee"]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _consultOption("Video", Icons.videocam_outlined, "video",
            doctorDetail!["videoFee"]),
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
          color: selected ? ColorConstant.colorIntroBG.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? ColorConstant.colorIntroBG : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(icon,
                  color: selected ? ColorConstant.colorIntroBG : Colors.black87),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color:
                      selected ? ColorConstant.colorIntroBG : Colors.black87)),
            ]),
            Text("₹$fee",
                style: TextStyle(
                    color: selected ? ColorConstant.colorIntroBG : Colors.black87,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  void _selectDateFromApi() {
    if (availabilities.isEmpty) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: availabilities.map((a) {
            final date = a["date"] as DateTime;
            final formatted = "${date.day}/${date.month}/${date.year}";
            return ListTile(
              title: Text(formatted),
              textColor: ColorConstant.colorIntroBG,
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
            );
          }).toList(),
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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(slots.length, (index) {
            final slot = slots[index];
            final time = slot["time"];
            final isBooked = slot["isBooked"];
            final individualSlotId = slot["slotId"];

            return ChoiceChip(
              label: Text(time),
              selected: _selectedTime == time,
              selectedColor: ColorConstant.colorIntroBG,
              labelStyle: TextStyle(
                  color: _selectedTime == time ? Colors.white : Colors.black87
              ),
              backgroundColor: isBooked ? Colors.grey.shade200 : Colors.grey.shade100,
              onSelected: (_) {
                Navigator.pop(context);
                setState(() {
                  _selectedTime = time;
                  // ✅ Store the availability ID as slotId for booking
                  _selectedSlotId = availabilityId;

                  if (isBooked == true && slot["alternativeDoctor"] != null) {
                    final altDoc = slot["alternativeDoctor"];
                    showBookedMessage = true;
                    alternativeDoctors = [
                      {
                        "_id": altDoc["_id"] ?? "",
                        "name": altDoc["fullName"] ?? altDoc["name"] ?? "Doctor",
                        "photo": altDoc["profile_photo"] ?? "",
                        "avgRating": altDoc["avgRating"] ?? 0,
                        "totalReviews": altDoc["totalReviews"] ?? 0,
                        "specialization": doctorDetail?["speciality"] ?? "Specialist",
                        "availabilities": altDoc["availabilities"] ?? [],
                        "chatFee": altDoc["chatFee"] ?? 200,
                        "audioFee": altDoc["voiceCallFee"] ?? 300,
                        "videoFee": altDoc["videoCallFee"] ?? 600,
                        "about": altDoc["about"] ?? "",
                        "languages": altDoc["languages"] ?? ["English"],
                      }
                    ];
                  } else {
                    showBookedMessage = false;
                    alternativeDoctors.clear();
                  }
                });
              },
            );
          }),
        ),
      ),
    );
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
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: (doc["photo"] != null && doc["photo"].toString().isNotEmpty)
                        ? NetworkImage(doc["photo"])
                        : const AssetImage("assets/Images/default_doctor.png") as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doc["name"],
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                      const Icon(Icons.star, size: 16, color: Colors.amberAccent),
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