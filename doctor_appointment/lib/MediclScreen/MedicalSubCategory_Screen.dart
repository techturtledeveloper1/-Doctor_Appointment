import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../ApiService/ApiService.dart';
import '../Utils/ColorConstant.dart';
import 'ProductDetails_Screen.dart';

class ProductListingScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const ProductListingScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  List<Map<String, dynamic>> products = [];
  Map<String, dynamic>? productData;
  bool isLoading = true;
  PlatformFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    loadCategoryData();
  }

  // ✅ Fetch product details
  void loadCategoryData() async {
    var response =
    await ApiService().callGetMedicineCategoryById(widget.categoryId);

    debugPrint("📢 API RESULT: $response");

    if (response != null && response['success'] == true) {
      var item = response['data'];

      products = [
        {
          "_id": (item['_id'] ?? "").toString(),
          "name": (item['name'] ?? "Unknown"),
          "price": (item['price'] ?? 0).toString(),
          "image": item['images'] != null && item['images'].isNotEmpty
              ? item['images'][0]
              : "",
        }
      ];
    } else {
      debugPrint("❌ Failed to load item data");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _addToCart(String productId) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            SizedBox(width: 12),
            Text("Adding to cart..."),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );

    Map<String, dynamic> body = {
      "items": [
        {
          "medicineId": productId,
          "quantity": 1
        }
      ]
    };

    debugPrint("🛒 Add to Cart Request: $body");

    var response = await ApiService().callAddToCartApi(body);

    if (response != null && response['success'] == true) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Added to cart successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      String errorMessage = "❌ Failed to add to cart";
      if (response != null && response['message'] != null) {
        errorMessage = "❌ ${response['message']}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: ColorConstant.colorIntroBG,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Mental Wellness Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Mental Wellness, Our Priority",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Flat 15% OFF on Mental Health Essentials",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // ✅ Categories Section
            Text(
              "Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryItem("Antidepressants", Icons.mood),
                _buildCategoryItem("Anti-anxiety", Icons.psychology),
                _buildCategoryItem("Sleep", Icons.nightlight_round),
              ],
            ),
            SizedBox(height: 20),

            // ✅ Divider
            Divider(color: Colors.grey[300], height: 1),
            SizedBox(height: 20),

            // ✅ Featured Products Section
            Text(
              "Featured Products",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // ✅ Products Grid - FIXED: Better aspect ratio and layout
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = products[index];
                return GestureDetector(
                  onTap: () {
                    /// ✅ Only open if ID is not empty
                    if (item["_id"].toString().isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: item["_id"],
                          ),
                        ),
                      );
                    }
                  },
                  child: _productCard(item),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: ColorConstant.colorIntroBG.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, size: 30, color: ColorConstant.colorIntroBG),
        ),
        SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _productCard(Map<String, dynamic> item) {
    bool requiresRx = item['requiresRx'] ?? false;
    String dosage = item['dosage'] ?? '';
    String productId = item['_id'].toString();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Product Image - Fixed height
              Container(
                height: constraints.maxWidth * 0.5, // Responsive height based on width
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: item['image'] != null && item['image'].toString().isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.medical_services,
                            size: 40, color: Colors.grey[400]),
                      );
                    },
                  ),
                )
                    : Center(
                  child: Icon(Icons.medical_services,
                      size: 40, color: Colors.grey[400]),
                ),
              ),

              // ✅ Product Content - Flexible space
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ✅ Top Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Product Name
                          Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 4),

                          // ✅ Dosage if available
                          if (dosage.isNotEmpty)
                            Text(
                              dosage,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),

                          SizedBox(height: 4),

                          // ✅ Price
                          Text(
                            "₹${item['price']}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.colorIntroBG,
                            ),
                          ),

                          SizedBox(height: 4),

                          // ✅ Rx Required badge
                          if (requiresRx)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.orange!),
                              ),
                              child: Text(
                                "Rx Required",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // ✅ Add to Cart Button - Now calls _addToCart function
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.colorIntroBG,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            _addToCart(productId);
                          },
                          child: Text(
                            "Add to cart",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}