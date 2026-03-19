import 'dart:async';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'FeaturedDoctor/FeaturedDoctor_Screen.dart';
import 'TalkDoctor/DoctorList_Screen.dart';
import 'TalkDoctor/Speiality_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  Timer? _bannerTimer;

  // 🔹 Banner images
  final List<String> banners = [
    AppImages.slider1,
    AppImages.slider2,
    AppImages.slider3,
  ];

  // 🔹 Specializations
  final List<Map<String, dynamic>> specializations = [
    {"title": "Psychiatry", "icon": "🧠", "speciality": "Psychiatrist"},
    {"title": "Neurology", "icon": "🧩", "speciality": "Neurologist"},
    {"title": "Dermatology", "icon": "💆‍♂️", "speciality": "Dermatologist"},
    {"title": "Pediatrics", "icon": "👶", "speciality": "Pediatrician"},
    {"title": "Cardiology", "icon": "❤️", "speciality": "Cardiologist"},
    {"title": "Endocrinology", "icon": "🩺", "speciality": "Endocrinologist"},
  ];

  // 🔹 Services
  final List<Map<String, dynamic>> services = [
    {
      "icon": Icons.phone_android,
      "label": "Talk to Doctor",
      "color": AppColor.textColor2,
    },
    {"icon": Icons.science, "label": "Lab Tests", "color": AppColor.textColor2},
    {
      "icon": Icons.medical_services,
      "label": "Medicines",
      "color": AppColor.textColor2,
    },
    {
      "icon": Icons.home,
      "label": "Home Health Care",
      "color": AppColor.textColor2,
    },
    {
      "icon": Icons.local_hospital,
      "label": "Surgeries",
      "color": AppColor.textColor2,
    },
    {"icon": Icons.add, "label": "Radiology", "color": AppColor.textColor2},
  ];

  // 🔹 Featured Doctors
  final List<Map<String, dynamic>> featuredDoctors = [
    {
      "name": "Dr. A. Mehta",
      "speciality": "Psychiatrist",
      "rating": 4.8,
      "available": "Today, 4 PM",
    },
    {
      "name": "Dr. S. Patel",
      "speciality": "Neurologist",
      "rating": 4.6,
      "available": "Mon, 11 AM",
    },
  ];

  // 🔹 Upcoming Appointments
  final List<Map<String, String>> upcomingAppointments = [
    {
      "doctor": "Dr. Mehta",
      "speciality": "Psychiatrist",
      "time": "Mon, Sep 8 · 10:00 AM",
      "status": "Confirmed",
    },
    {
      "doctor": "Dr. Shah",
      "speciality": "Neurologist",
      "time": "Wed, Sep 10 · 3:00 PM",
      "status": "Pending",
    },
  ];

  // 🔹 Health Packages
  final List<Map<String, String>> packages = [
    {
      "title": "THS Full body Care!",
      "price": "₹899",
      "image": AppImages.family,
    },
    {
      "title": "THS Silver Wellness",
      "price": "₹1599",
      "image": AppImages.family,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // 🔄 Auto Banner Slider
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (_selectedIndex < banners.length - 1) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }
      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Hello, Harsh 👋",
                            style: TextStyle(
                              color: AppColor.colorPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Banner Carousel
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: banners.length,
                            onPageChanged: (index) {
                              setState(() => _selectedIndex = index);
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  image: DecorationImage(
                                    image: AssetImage(banners[index]),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            banners.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _selectedIndex == index ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.white54,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ===== Specializations =====
              _sectionTitle(
                "SPECIALIZATIONS",
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SpecialityScreen()),
                  );
                },
              ),

              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: specializations.length,
                  itemBuilder: (context, index) {
                    final item = specializations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorListScreen(
                              speciality: item["title"],
                              selectedSymptoms: [],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: _cardDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item["icon"],
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                item["title"],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // ===== Our Services =====
              _sectionTitle("OUR SERVICES"),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = services[index];
                  return GestureDetector(
                    onTap: () {
                      // TODO: Add navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SpecialityScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item["color"] as Color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item["icon"] as IconData,
                            size: 28,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item["label"] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              // ===== Featured Doctors =====
              _sectionTitle("FEATURED DOCTORS"),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: featuredDoctors.length,
                  itemBuilder: (context, index) {
                    final doc = featuredDoctors[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeaturedDoctorsScreen(
                              featuredDoctors: featuredDoctors,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 260,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: _cardDecoration(),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                (doc["name"] as String)
                                    .split(' ')
                                    .map((s) => s.isNotEmpty ? s[0] : '')
                                    .take(2)
                                    .join(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    doc["name"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    doc["speciality"],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber.shade700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${doc["rating"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "• ${doc["available"]}",
                                            style: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              // ===== Upcoming Appointments =====
              _sectionTitle("UPCOMING APPOINTMENTS"),
              Column(
                children: upcomingAppointments.map((appt) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: _cardDecoration(),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appt["doctor"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appt["speciality"]!,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              appt["time"]!,
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: appt["status"] == "Confirmed"
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                appt["status"]!,
                                style: TextStyle(
                                  color: appt["status"] == "Confirmed"
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // ===== Health Packages =====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "HEALTH PACKAGES",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: packages.length,
                  padding: const EdgeInsets.only(left: 16),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 170,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Image.asset(
                              packages[index]["image"]!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  packages[index]["title"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Starting from ${packages[index]["price"]}",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ===== Pro Plan =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "THS PRO PLAN",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Avail special discounts",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {},
                      child: const Text("Join THS PRO PLAN"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Section Title
  Widget _sectionTitle(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.colorPrimary,
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                "View All",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.colorPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 🔹 Reusable Card Style
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    );
  }
}
