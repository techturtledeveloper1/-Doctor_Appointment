import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/screen/profile_screen/Settings/Changedpasswordscreen.dart';
import 'package:flutter/material.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       appBar: AppBar(
//         title: Text("Settings", style: TextStyle(color: AppColor.colorIntroBG)),
//         backgroundColor: AppColor.white,
//         iconTheme: IconThemeData(color: AppColor.colorIntroBG),
//       ),
//       body: ListView(
//         children: [
//           SwitchListTile(
//             title: Text("Dark Mode"),
//             activeColor: AppColor.colorIntroBG,
//             value: false,
//             onChanged: (val) {},
//           ),
//           ListTile(
//             leading: Icon(Icons.lock, color: AppColor.colorIntroBG),
//             title: Text("Change Password"),
//             trailing: Icon(
//               Icons.arrow_forward_ios,
//               size: 16,
//               color: Colors.grey,
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ChangePasswordScreen(),
//                 ),
//               );
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.logout, color: Colors.red),
//             title: Text("Logout", style: TextStyle(color: Colors.red)),
//             onTap: () {
//               // TODO: Add your logout logic
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        backgroundColor: AppColor.colorPrimary,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(height: 16),

          _sectionTitle("Account"),

          _buildTile(
            icon: Icons.lock,
            title: "Change Password",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          SizedBox(height: 16),

          _sectionTitle("General"),

          _buildTile(
            icon: Icons.description,
            title: "Terms & Conditions",
            onTap: () {},
          ),

          _buildTile(
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
            onTap: () {},
          ),

          _buildTile(
            icon: Icons.support_agent,
            title: "Contact Us",
            onTap: () {},
          ),

          _buildTile(icon: Icons.star_rate, title: "Rate Us", onTap: () {}),

          _buildTile(icon: Icons.feedback, title: "Feedback", onTap: () {}),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return _buildCard(
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: AppColor.colorPrimary),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
