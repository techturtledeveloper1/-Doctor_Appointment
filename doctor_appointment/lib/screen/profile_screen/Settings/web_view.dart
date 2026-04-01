import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: AppColor.white)),
        backgroundColor: AppColor.colorPrimary,
        iconTheme: IconThemeData(color: AppColor.white, size: 24),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
