import 'package:flutter/material.dart';
import '../../Utils/AppColor.dart';
import '../ProductDetailsScreen/ProductDetail_Screen.dart';

class MentalHealthCategoryScreen extends StatelessWidget {
  final String categoryName;

  MentalHealthCategoryScreen({required this.categoryName});

  final List<String> subCategories = [
    "Antidepressants",
    "Anti-anxiety",
    "Sleep Aids",
    "Mood Stabilizers",
    "Cognitive Boosters",
    "Natural Stress Relief",
  ];

  final List<Map<String, dynamic>> featuredProducts = [
    {"name": "Sertraline", "desc": "50 mg", "price": "₹120 / strip", "rx": true},
    {"name": "Melatonin Sleep Gummies", "desc": "", "price": "₹399", "rx": false},
    {"name": "Clonazepam", "desc": "0.5 mg", "price": "₹95 / strip", "rx": true},
    {"name": "Omega-3 Brain Support", "desc": "", "price": "₹599", "rx": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology, color: Colors.blue, size: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Mental Wellness, Our Priority",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 4),
                        Text("Flat 15% OFF on Mental Health Essentials"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),

            // Chips -> Horizontal Scroll
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: subCategories.map((cat) {
                  bool selected = cat == categoryName;
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColor.colorIntroBG
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            // Upload prescription
            GestureDetector(
              onTap: () {
                // TODO: implement file picker here
              },
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.colorIntroBG),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.upload_file, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Upload a prescription"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Featured Products
            Text("Featured Products",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: featuredProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = featuredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: item),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Icon/Image
                        Center(
                          child: Icon(Icons.medication,
                              size: 50, color: Colors.teal),
                        ),
                        SizedBox(height: 6),

                        // Name & Desc
                        Text(item['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        if (item['desc'] != null && item['desc'] != "")
                          Text(item['desc'],
                              style:
                              TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(height: 4),

                        // Price
                        Text(item['price'],
                            style: TextStyle(
                                fontSize: 14, color: Colors.black87)),
                        SizedBox(height: 6),

                        // Rx Tag (kept fixed height for alignment)
                        if (item['rx'])
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text("Rx Required",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          )
                        else
                          SizedBox(height: 10), // placeholder for alignment
                        Spacer(),

                        // Add to cart
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.colorIntroBG,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(double.infinity, 36),
                          ),
                          child: Text("Add to cart",style:TextStyle(color: AppColor.white),),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
