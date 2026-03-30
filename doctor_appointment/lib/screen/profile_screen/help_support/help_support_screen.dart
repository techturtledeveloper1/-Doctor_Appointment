import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/ReusableWidget/app_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController issueController = TextEditingController();

  final List<Map<String, String>> faqs = [
    {
      "q": "How to book an appointment?",
      "a": "Go to doctor profile and click on Book Appointment.",
    },
    {
      "q": "How to cancel appointment?",
      "a": "Go to My Appointments and select cancel option.",
    },
    {
      "q": "Payment failed but money deducted?",
      "a": "Amount will be refunded within 5-7 working days.",
    },
    {
      "q": "How to contact doctor?",
      "a": "Use chat or call option available in appointment.",
    },
  ];

  Future<void> _launchPhone() async {
    final Uri url = Uri(scheme: 'tel', path: '8401111558');
    await launchUrl(url);
  }

  Future<void> _launchEmail() async {
    final Uri url = Uri(scheme: 'mailto', path: 'support@doctorapp.com');
    await launchUrl(url);
  }

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/918200335815");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void _submitIssue() {
    if (issueController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your issue")));
      return;
    }

    Navigator.pop(context);

    issueController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,

      appBar: AppBar(
        backgroundColor: AppColor.colorPrimary,
        title: Text(
          "Help Center",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        iconTheme: IconThemeData(color: AppColor.white),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.colorPrimary, AppColor.colorAccent],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Icon(Icons.headset_mic, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "Need Help?",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "We're here for you 24/7",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _contactCard(Icons.call, "Call", _launchPhone),
                _contactCard(Icons.email, "Email", _launchEmail),
                _contactCard(Icons.chat, "WhatsApp", _launchWhatsApp),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("Frequently Asked Questions"),
            ...faqs.map(
              (e) => Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.white,

                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),

                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    backgroundColor: AppColor.white,
                    title: Text(
                      e["q"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 12,
                        ),
                        child: Text(e["a"]!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 Report Issue
            _sectionTitle("Report an Issue"),
            AppEditText(
              controller: issueController,
              maxLines: 5,
              minLines: 5,
              hint: "Describe your problem...",
              name: "",
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: AppButton(onPressed: _submitIssue, text: "Submit"),
            ),
            const SizedBox(height: 20),

            /// 🔹 CONTACT
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColor.white,
              child: Column(
                children: const [
                  Text(
                    "Contact Us",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("📞 +91 9874563156"),
                  Text("📧 support@doctorapp.com"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(IconData icon, String title, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: AppColor.colorPrimary.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: AppColor.colorPrimary),
              const SizedBox(height: 6),
              Text(title, style: TextStyle(color: AppColor.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
