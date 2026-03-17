import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../ApiService/ApiService.dart';
import '../Utils/ColorConstant.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Map<String, dynamic>? productData;
  bool isLoading = true;
  bool _prescriptionUploaded = false;
  PlatformFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    loadProductDetails();
  }

  void loadProductDetails() async {
    var response =
    await ApiService().callGetMedicineDetailsById(widget.productId);

    if (response != null && response['success'] == true) {
      setState(() {
        productData = response['data'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
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
          _prescriptionUploaded = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading prescription: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addToCart() async {
    String productId = productData!['_id']; // ✅ medicineId from API

    Map<String, dynamic> body = {
      "items": [
        {
          "medicineId": productId,
          "quantity": 1
        }
      ]
    };

    var response = await ApiService().callAddToCartApi(body);

    if (response != null && response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Added to cart successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Failed to add to cart"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: ColorConstant.colorIntroBG,
          ),
        ),
      );
    }

    if (productData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: Center(child: Text("❌ Failed to load product details.")),
      );
    }

    var item = productData!;
    var imageUrl = item['images'] != null && item['images'].isNotEmpty
        ? item['images'][0]
        : null;

    bool requiresPrescription = item['prescriptionRequired'] == true;
    double originalPrice = (item['price'] ?? 0).toDouble();
    double discountedPrice = originalPrice * 0.85; // 15% OFF
    String dosage = item['dosage'] ?? '50 mg';
    String description = item['description'] ?? 'Helps regulate sleep cycles, supports relaxation.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          item['name'] ?? "Product",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ PRODUCT IMAGE
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              )
                  : Icon(Icons.medical_services,
                  size: 80, color: ColorConstant.colorIntroBG),
            ),

            SizedBox(height: 20),

            /// ✅ PRODUCT NAME
            Text(
              item['name'] ?? 'Sertraline',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            /// ✅ DOSAGE
            Text(
              dosage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 12),

            /// ✅ PRICE WITH DISCOUNT
            Row(
              children: [
                Text(
                  "₹$originalPrice",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "₹${discountedPrice.toInt()} / strip",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.colorIntroBG,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    "15% OFF",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            /// ✅ DESCRIPTION
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            SizedBox(height: 20),

            /// ✅ PRESCRIPTION REQUIREMENT
            if (requiresPrescription) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: Colors.orange[800],
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Prescription required for this product",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    /// ✅ PRESCRIPTION UPLOAD SECTION
                    GestureDetector(
                      onTap: _uploadPrescription,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _prescriptionUploaded ? Colors.green[50] : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _prescriptionUploaded ? Colors.green : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _prescriptionUploaded ? Colors.green : Colors.grey,
                                ),
                                color: _prescriptionUploaded ? Colors.green : Colors.transparent,
                              ),
                              child: _prescriptionUploaded
                                  ? Icon(Icons.check, size: 14, color: Colors.white)
                                  : null,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload Prescription",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (_pickedFile != null) ...[
                                    SizedBox(height: 4),
                                    Text(
                                      _pickedFile!.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.upload_file,
                              color: _prescriptionUploaded ? Colors.green : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],

            /// ✅ RATINGS AND REVIEWS
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  /// ✅ STAR RATING
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star_half, color: Colors.amber, size: 20),
                    ],
                  ),
                  SizedBox(width: 8),

                  /// ✅ RATING TEXT
                  Text(
                    "4.6",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "(120 Reviews)",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 100),
          ],
        ),
      ),

      /// ✅ BOTTOM ACTION BUTTONS
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ✅ ADD TO CART BUTTON
            Expanded(
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: ColorConstant.colorIntroBG,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: ColorConstant.colorIntroBG, width: 2),
                  ),
                ),
                onPressed: () {
                  if (requiresPrescription && !_prescriptionUploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("⚠️ Please upload prescription first"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  _addToCart();
                },

                child: Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),

            /// ✅ BUY NOW BUTTON
            Expanded(
              flex: 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (requiresPrescription && !_prescriptionUploaded)
                    ? null
                    : () {
                  // Buy now functionality
                },
                child: Text(
                  "Buy Now",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}