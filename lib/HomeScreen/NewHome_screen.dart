import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../AppointmentScreen/Appointment_Screen.dart';
import '../Utils/ColorConstant.dart';
import 'ConsultPsychiatristScreen/ConsultPsychiatrist_Screen.dart';
import 'OrderMedicineScreen/OrderMedicine_Screen.dart';
import 'OrderMedicineScreen/TrackOrder_Screen.dart';

class NewhomeScreen extends StatefulWidget {
  const NewhomeScreen({super.key});

  @override
  State<NewhomeScreen> createState() => _NewhomeScreenState();
}

class _NewhomeScreenState extends State<NewhomeScreen> {

  int _currentIndex = 0;

  final List<String> bannerImages = [
    "assets/Images/Banner.png",
    "assets/Images/Banner1.png",
    "assets/Images/Banner2.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                "Hi, Serenest 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.colorIntroBG,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Welcome back! What would you like to do today?",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstant.colorTextWelcome,
                ),
              ),

              const SizedBox(height: 16),

              CarouselSlider(
                options: CarouselOptions(
                  height: 180, // increased height
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1, // full width
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
                          ? ColorConstant.colorIntroBG
                          : Colors.grey.shade400,
                    ),
                  );
                }).toList(),
              ),


              const SizedBox(height: 20),

              // Consult Now Card
              // Card(
              //   elevation: 4,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(16)),
              //   child: Container(
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(16),
              //       color: ColorConstant.textColor2,
              //     ),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Consult Now",
              //                   style: TextStyle(
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.bold,
              //                       color: ColorConstant.colorIntroBG)),
              //               const SizedBox(height: 8),
              //               ElevatedButton(
              //                 style: ElevatedButton.styleFrom(
              //                   backgroundColor: ColorConstant.colorIntroBG,
              //                   foregroundColor: Colors.white,
              //                   shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(12)),
              //                 ),
              //                 onPressed: () {},
              //                 child: const Text("Consult Now"),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Image.asset("assets/Images/d1.png",
              //             height: 80, fit: BoxFit.contain),
              //       ],
              //     ),
              //   ),
              // ),

              const SizedBox(height: 20),

              // Services
              // Services Section
              // Services Section
              Text("Our Services",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.colorIntroBG,
                      fontSize: 16)),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _serviceCard("assets/Images/psychiatrist.png", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConsultPsychiatristScreen()),
                    );
                  }),
                  _serviceCard("assets/Images/psychologist.png", onTap: () {
                    // Navigate to Psychologist
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConsultPsychiatristScreen()),
                    );
                  }),
                  _serviceCard("assets/Images/therapist.png", onTap: () {
                    // Navigate to Therapist
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConsultPsychiatristScreen()),
                    );
                  }),
                  _serviceCard("assets/Images/medicine.png", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderMedicineScreen()),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 24),

              // Featured Doctors
              Text("Featured Psychiatrists",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.colorIntroBG,
                      fontSize: 16)),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const CircleAvatar(
                          radius: 28,
                          backgroundImage:
                          AssetImage("assets/Images/d4.png")),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Dr. Jenny Wilson",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(height: 2),
                            Text("Psychiatrist",
                                style: TextStyle(color: Colors.black54)),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.amber, size: 18),
                                SizedBox(width: 4),
                                Text("4.5 (12)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.colorIntroBG,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: const Text("Book Now"),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Delivery Tracker
              // Delivery Tracker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "On the way",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.colorIntroBG,
                        fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: (){
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
                                "status": "true"
                              },
                              {
                                "icon": "packed",
                                "title": "Packed",
                                "subtitle": "April 5, 9:00 AM",
                                "status": "true"
                              },
                              {
                                "icon": "delivery",
                                "title": "Out for Delivery",
                                "subtitle": "April 5, 2:45 PM",
                                "status": "true"
                              },
                              {
                                "icon": "delivered",
                                "title": "Delivered",
                                "subtitle": "",
                                "status": "false"
                              },
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Show >",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.colorIntroBG,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

// 🔹 Stepper with line
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Line + active dot
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Full grey line
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Active progress line
                      FractionallySizedBox(
                        widthFactor: 0.5, // 👉 progress (0.0 to 1.0)
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          bool active = index < 2; // 👉 change current step here
                          return CircleAvatar(
                            radius: 6,
                            backgroundColor: active ? Colors.teal : Colors.grey,
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Verified",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                      Text("Packed",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                      Text("Out for Delivery",
                          style: TextStyle(fontSize: 12, color: Colors.black54)),
                      Text("Delivered",
                          style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Services Widget
  Widget _serviceItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: ColorConstant.textColor2.withOpacity(0.3),
            child: Icon(icon, size: 28, color: ColorConstant.colorIntroBG),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _serviceCard(String imagePath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.textColor2.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10), // keep some padding
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover, // 👉 fills the card completely
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _bannerCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 6,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(left: 2 , right: 2 , top: 2),
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}

// Stepper widget for delivery
class _step extends StatelessWidget {
  final String label;
  final bool active;

  const _step(this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: active ? Colors.teal : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: active ? Colors.teal : Colors.grey,
                fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
