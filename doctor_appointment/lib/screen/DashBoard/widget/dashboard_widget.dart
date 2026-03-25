import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/HomeScreen/TalkDoctor/DoctorBookAppointment/doctor_list_view_all_screen.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_images.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import '../../../HomeScreen/ConsultPsychiatristScreen/ConsultPsychiatrist_Screen.dart';
import '../../../HomeScreen/ConsultPsychiatristScreen/DoctorDetails/DoctorDetails_Screen.dart';
import '../../../HomeScreen/OrderMedicineScreen/OrderMedicine_Screen.dart';
import '../../../HomeScreen/OrderMedicineScreen/TrackOrder_Screen.dart';

class DashBoardWidget extends StatefulWidget {
  const DashBoardWidget({super.key});

  @override
  State<DashBoardWidget> createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  int _currentIndex = 0;

  final List<String> bannerImages = [
    AppImages.banner1,
    AppImages.banner2,
    AppImages.banner3,
  ];

  Map<String, dynamic>? homeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHomeData(); // call API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, Serenest 👋",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.colorPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Welcome back! What would you like to do today?",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.colorTextWelcome,
                      ),
                    ),

                    const SizedBox(height: 16),

                    CarouselSlider(
                      options: CarouselOptions(
                        // height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        autoPlayInterval: const Duration(seconds: 3),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: bannerImages.map((imagePath) {
                        return _bannerCard(imagePath);
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bannerImages.asMap().entries.map((entry) {
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == entry.key
                                ? AppColor.colorPrimary
                                : Colors.grey.shade400,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Our Services",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.colorPrimary,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DoctorListViewAllScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "View all",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        if (homeData!["topSpecializations"] != null &&
                            homeData!["topSpecializations"].length > 0)
                          _serviceCard(
                            AppImages.psychiatrist,

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ConsultPsychiatristScreen(
                                    specializationId:
                                        homeData!["topSpecializations"][0]["_id"] ??
                                        "",
                                  ),
                                ),
                              );
                            },
                          ),
                        if (homeData!["topSpecializations"] != null &&
                            homeData!["topSpecializations"].length > 1)
                          _serviceCard(
                            AppImages.psychologist,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ConsultPsychiatristScreen(
                                    specializationId:
                                        homeData!["topSpecializations"][1]["_id"] ??
                                        "",
                                  ),
                                ),
                              );
                            },
                          ),
                        if (homeData!["topSpecializations"] != null &&
                            homeData!["topSpecializations"].length > 2)
                          _serviceCard(
                            AppImages.therapist,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ConsultPsychiatristScreen(
                                    specializationId:
                                        homeData!["topSpecializations"][2]["_id"] ??
                                        "",
                                  ),
                                ),
                              );
                            },
                          ),
                        _serviceCard(
                          AppImages.order_medicine,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrderMedicineScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Featured Psychiatrists",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.colorPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (homeData != null && homeData!["topDoctor"] != null)
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                  homeData!["topDoctor"]["image"] ?? "",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      homeData!["topDoctor"]["name"] ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      homeData!["topDoctor"]["specialization"] ??
                                          "",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${homeData!["topDoctor"]["avgRating"]} "
                                          "(${homeData!["topDoctor"]["totalReviews"]})",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              AppButton(
                                onPressed: () {
                                  final doctorId =
                                      homeData!['topDoctor']["id"]
                                          ?.toString() ??
                                      "";
                                  if (doctorId.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Doctor ID not available",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorDetailScreen(
                                        doctorId: doctorId,
                                      ),
                                    ),
                                  );
                                },
                                text: "Book Now",
                                width: 100,
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Text("No psychiatrists available right now."),

                    const SizedBox(height: 24),

                    AppButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrackOrderScreen(
                              prescriptionId: "709325647",
                              orderDate: "April 4, 2024",
                              totalAmount: 375,
                              courierPartner: "ABC Logistics",
                              trackingId: "ABCD123456",
                              trackingSteps: [
                                {
                                  "icon": "verified",
                                  "title": "Verified",
                                  "subtitle": "April 4, 12:30 PM",
                                  "status": "true",
                                },
                                {
                                  "icon": "packed",
                                  "title": "Packed",
                                  "subtitle": "April 5, 9:00 AM",
                                  "status": "true",
                                },
                                {
                                  "icon": "delivery",
                                  "title": "Out for Delivery",
                                  "subtitle": "April 5, 2:45 PM",
                                  "status": "true",
                                },
                                {
                                  "icon": "delivered",
                                  "title": "Delivered",
                                  "subtitle": "",
                                  "status": "false",
                                },
                              ],
                            ),
                          ),
                        );
                      },
                      text: "On the way",
                      iconColor: AppColor.white,
                      iconPosition: IconPosition.right,
                      icon: Icons.arrow_circle_right_outlined,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _bannerCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }

  Widget _serviceCard(String imagePath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.textColor2.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  /// API call
  Future<void> getHomeData() async {
    ApiService apiService = ApiService();
    apiService.callGetHomeScreenList().then((res) {
      setState(() {
        if (res != null && res["success"] == true) {
          homeData = res["data"];
          isLoading = false;
        } else {
          isLoading = false;
        }
      });
    });
  }
}
