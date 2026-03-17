import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../APIService/ApiService.dart';
import '../MediclScreen/MedicalSubCategory_Screen.dart';
import '../Utils/AppColor.dart';
import 'MentalHealthCategoryScreen/MentalHealthCategory_Screen.dart';

class MedicalStoreListScreen extends StatefulWidget {
  @override
  State<MedicalStoreListScreen> createState() => _MedicalStoreListScreenState();
}

class _MedicalStoreListScreenState extends State<MedicalStoreListScreen> {
  List<dynamic> activeCategories = [];
  bool isLoading = true;
  String selectedTab = "";
  PlatformFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    var data = await ApiService().callMedicineActivecategory();

    if (data != null && data['data'] != null) {
      setState(() {
        activeCategories = data['data'];  // <-- API response list
        if (activeCategories.isNotEmpty) {
          selectedTab = activeCategories[0]['name']; // First tab selected
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _uploadPrescription() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
        });

        // Here you can call your API to upload the file
        // await ApiService().uploadPrescription(_pickedFile!);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // User canceled the picker
        print('File picker canceled');
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading prescription: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())      // ✅ Loader
          : activeCategories.isEmpty
          ? Center(child: Text("No categories found"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Dynamic Horizontal Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: activeCategories.map((cat) {
                  bool selected = selectedTab == cat['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = cat['name'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColor.colorIntroBG
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat['name'],
                        style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            // ✅ Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search products",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // ✅ Prescription Upload Section - ADDED THIS
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E8), // Light green background
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flat 20% OFF on first medicine order",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Have a doctor's prescription? Upload it here",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _uploadPrescription,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.colorIntroBG,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  // Show selected file name if any
                  if (_pickedFile != null) ...[
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.attach_file, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _pickedFile!.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[600],
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 16),
                          onPressed: () {
                            setState(() {
                              _pickedFile = null;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),

            // ✅ Dynamic Category View
            Expanded(
              child: _buildDynamicCategoryUI(),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Category UI based on Selected Tab
  Widget _buildDynamicCategoryUI() {
    var selectedData = activeCategories.firstWhere(
            (e) => e['name'] == selectedTab,
        orElse: () => null);

    if (selectedData == null) {
      return Center(child: Text("Category not found"));
    }

    // ✅ Correct API key: "subcategories"
    List subCat = selectedData['subcategories'] ?? [];

    if (subCat.isEmpty) {
      return Center(child: Text("No subcategories found"));
    }

    return GridView.builder(
      itemCount: subCat.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListingScreen(
                  categoryName: subCat[index]['name'],
                  categoryId: subCat[index]['_id'],  // ✅
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_services,
                    color: AppColor.colorIntroBG, size: 32),
                SizedBox(height: 8),
                Text(
                  subCat[index]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}