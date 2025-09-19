import 'package:flutter/material.dart';
import '../../Utils/ColorConstant.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: ColorConstant.colorIntroBG)),
        backgroundColor: ColorConstant.colorWhite,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Dark Mode"),
            activeColor: ColorConstant.colorIntroBG,
            value: false,
            onChanged: (val) {},
          ),
          ListTile(
            leading: Icon(Icons.lock, color: ColorConstant.colorIntroBG),
            title: Text("Change Password"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
