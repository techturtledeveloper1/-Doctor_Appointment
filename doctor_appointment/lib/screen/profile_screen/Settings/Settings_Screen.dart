import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_edit_text.dart';
import 'package:doctor_appointment/screen/profile_screen/Settings/Changedpasswordscreen.dart';
import 'package:doctor_appointment/screen/profile_screen/Settings/web_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WebViewPage(
                    title: "Terms & Conditions",
                    url: "https://serenest.co.in/terms-of-service.html",
                  ),
                ),
              );
            },
          ),

          _buildTile(
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WebViewPage(
                    title: "Privacy Policy",
                    url: "https://serenest.co.in/privacy.html",
                  ),
                ),
              );
            },
          ),

          _buildTile(
            icon: Icons.support_agent,
            title: "Contact Us",
            onTap: () {
              showContactDialog(context);
            },
          ),

          _buildTile(
            icon: Icons.star_rate,
            title: "Rate Us",
            onTap: () {
              openPlayStore();
            },
          ),

          _buildTile(
            icon: Icons.feedback,
            title: "Feedback",
            onTap: () {
              showFeedbackDialog(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => FeedbackPage()),
              // );
            },
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  void showFeedbackDialog(BuildContext context) {
    TextEditingController feedbackCtrl = TextEditingController();
    int rating = 0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
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
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                rating = index + 1;
                              });
                            },
                            icon: Icon(
                              Icons.star,
                              color: index < rating
                                  ? Colors.orange
                                  : Colors.grey.shade300,
                              size: 30,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "We need your feedback",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "How would you rate your experience\nwith the app today?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      const SizedBox(height: 15),

                      AppEditText(
                        controller: feedbackCtrl,
                        name: "",
                        maxLines: 5,
                        minLines: 5,
                        hint: "Write your note....",
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onPressed: () {
                            Navigator.pop(context);

                            Fluttertoast.showToast(
                              msg: "Feedback submitted successfully ✅",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 14,
                            );
                          },
                          text: "Submit",
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> openPlayStore() async {
    final Uri url = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.example.doctor_appointment",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open Play Store");
    }
  }

  void showContactDialog1(BuildContext context) {
    String name = "Dr. Chirag Ambaliya";
    String phone = "9876543210";
    String email = "doctor@gmail.com";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Contact Us"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: $name"),
              Text("Phone: $phone"),
              Text("Email: $email"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String value,
    Color color = Colors.blue,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 18),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showContactDialog(BuildContext context) {
    String name = "Dr. Chirag Ambaliya";
    String phone = "9876543210";
    String email = "doctor@gmail.com";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔘 Top Handle
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 35, color: Colors.blue),
              ),

              const SizedBox(height: 12),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text("Psychiatrist", style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 20),

              _modernTile(
                icon: Icons.phone,
                title: "Call",
                value: phone,
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              _modernTile(
                icon: Icons.email,
                title: "Email",
                value: email,
                color: Colors.orange,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: () => Navigator.pop(context),
                  text: "Close",
                  textStyle: TextStyle(fontSize: 16, color: AppColor.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔥 Modern Tile
  Widget _modernTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
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
