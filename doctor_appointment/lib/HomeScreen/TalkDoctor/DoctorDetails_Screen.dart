// import 'package:flutter/material.dart';
// import '../../Utils/ColorConstant.dart';
// import 'DoctorBookAppointment/DoctorBookAppointment_Screen.dart';
//
// class DoctorDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> doctor;
//
//   const DoctorDetailScreen({super.key, required this.doctor});
//
//   @override
//   Widget build(BuildContext context) {
//     // 🔹 Static available consultation types
//     const String availableTypes = "Video Call, Chat"; // static text
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: ColorConstant.colorIntroBG,
//         elevation: 0,
//         title: Text(
//           doctor["name"],
//           style: const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // 🔹 Doctor Image
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage(doctor["image"]),
//             ),
//             const SizedBox(height: 12),
//
//             // 🔹 Doctor Info
//             Text(
//               doctor["name"],
//               style: const TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               doctor["speciality"],
//               style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Experience: ${doctor["experience"]}",
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 12),
//
//             // 🔹 Online / Offline
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.circle,
//                     size: 14,
//                     color: doctor["online"] ? Colors.green : Colors.red),
//                 const SizedBox(width: 6),
//                 Text(
//                   doctor["online"] ? "Online" : "Offline",
//                   style: TextStyle(
//                       color:
//                       doctor["online"] ? Colors.green : Colors.red),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // 🔹 Description + Available for
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       spreadRadius: 2)
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctor["desc"],
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     "Available for: $availableTypes",
//                     style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: ColorConstant.colorIntroBG),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Spacer(),
//
//             // 🔹 Book Appointment Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ColorConstant.colorIntroBG,
//                   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => BookAppointmentScreen(
//                         doctor: doctor,
//                         onAppointmentBooked: (appointment) {
//                           // Here you can store or show the booked appointment
//                           print("Appointment booked: $appointment");
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   "Book Appointment",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
