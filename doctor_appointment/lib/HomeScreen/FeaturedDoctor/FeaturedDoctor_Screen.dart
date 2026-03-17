import 'package:flutter/material.dart';
import '../../Utils/AppColor.dart';

class FeaturedDoctorsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> featuredDoctors;

  const FeaturedDoctorsScreen({super.key, required this.featuredDoctors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Featured Doctors"),
        backgroundColor: AppColor.colorIntroBG,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: featuredDoctors.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final doc = featuredDoctors[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
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
              title: Text(
                doc["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc["speciality"], style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                      const SizedBox(width: 4),
                      Text("${doc["rating"]}"),
                      const SizedBox(width: 12),
                      Text(
                        "• ${doc["available"]}",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              onTap: () {
                // 🔹 Navigate to Doctor Detail Screen (optional)
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) => DoctorDetailScreen(doctor: doc),
                // ));
              },
            ),
          );
        },
      ),
    );
  }
}
