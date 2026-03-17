import 'package:flutter/material.dart';
import '../../../Utils/AppColor.dart';
import '../../../UserProfileScreen/Settings/Changedpasswordscreen.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: AppColor.colorIntroBG),
        ),
        backgroundColor: AppColor.white,
        iconTheme: IconThemeData(color: AppColor.colorIntroBG),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Dark Mode"),
            activeColor: AppColor.colorIntroBG,
            value: false,
            onChanged: (val) {},
          ),
          ListTile(
            leading: Icon(Icons.lock, color: AppColor.colorIntroBG),
            title: Text("Change Password"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Add your logout logic
            },
          ),
        ],
      ),
    );
  }
}
