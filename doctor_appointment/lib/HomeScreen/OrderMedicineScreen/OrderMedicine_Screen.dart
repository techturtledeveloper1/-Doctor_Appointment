import 'package:doctor_appointment/screen/DashBoard/DashBoard.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'MedicineCart_Screen.dart';

class OrderMedicineScreen extends StatefulWidget {
  const OrderMedicineScreen({super.key});

  @override
  State<OrderMedicineScreen> createState() => _OrderMedicineScreenState();
}

class _OrderMedicineScreenState extends State<OrderMedicineScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>>? uploadedMedicines; // Store extracted medicines
  String? prescriptionFileName; // Store uploaded PDF file name

  final List<Map<String, dynamic>> allMedicines = [
    {'name': 'Paracetamol', 'mg': 500, 'price': 50, 'quantity': 1},
    {'name': 'Amoxicillin', 'mg': 250, 'price': 75, 'quantity': 1},
    {'name': 'Ibuprofen', 'mg': 400, 'price': 60, 'quantity': 1},
  ];

  Future<void> pickAndReadPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => isLoading = true);
        prescriptionFileName = result.files.single.name; // store file name
        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        final PdfDocument document = PdfDocument(inputBytes: bytes);

        String extractedText = '';
        for (int i = 0; i < document.pages.count; i++) {
          extractedText += PdfTextExtractor(
            document,
          ).extractText(startPageIndex: i);
        }
        document.dispose();

        List<Map<String, dynamic>> foundMedicines = [];
        for (var med in allMedicines) {
          if (extractedText.toLowerCase().contains(med['name'].toLowerCase())) {
            foundMedicines.add(Map.from(med));
          }
        }

        setState(() {
          isLoading = false;
          uploadedMedicines = foundMedicines.isNotEmpty ? foundMedicines : null;
        });

        if (foundMedicines.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No medicines found in this PDF.")),
          );
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Medicines",
          style: TextStyle(color: AppColor.colorPrimary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Medicine Icon
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.medical_services_outlined,
                size: 80,
                color: AppColor.colorPrimary,
              ),
            ),
            const SizedBox(height: 40),

            // Upload Prescription Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: pickAndReadPDF,
                icon: Icon(Icons.upload_file, color: AppColor.colorIntroBG),
                label: Text(
                  uploadedMedicines != null
                      ? "Prescription Uploaded"
                      : "Upload Prescription",
                  style: TextStyle(color: AppColor.colorIntroBG),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColor.colorIntroBG),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Go to Medical Store Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashBoardNew(3, false, false),
                    ),
                  );
                },
                icon: Icon(
                  Icons.store_mall_directory,
                  color: AppColor.colorIntroBG,
                ),
                label: Text(
                  "Go to Medical Store",
                  style: TextStyle(color: AppColor.colorIntroBG),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColor.colorIntroBG),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info Text
            Text(
              "Prescriptions are verified by our pharmacists before dispatch.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColor.colorBlack),
            ),
            const SizedBox(height: 40),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: uploadedMedicines != null
                    ? () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => MedicineCartScreen(
                        //       medicines: uploadedMedicines!,
                        //       prescriptionFileName: prescriptionFileName!,
                        //     ),
                        //   ),
                        // );
                      }
                    : null, // Disable button if no prescription uploaded
                style: ElevatedButton.styleFrom(
                  backgroundColor: uploadedMedicines != null
                      ? AppColor.colorIntroBG
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(fontSize: 16, color: AppColor.white),
                ),
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
