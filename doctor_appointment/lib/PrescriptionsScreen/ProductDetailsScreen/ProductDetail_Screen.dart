import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(product['name']),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (placeholder for now)
            Center(
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.medication, size: 80, color: Colors.teal),
              ),
            ),
            SizedBox(height: 16),

            // Product Title
            Text(
              product['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (product['desc'] != null && product['desc'] != "")
              Text(product['desc'], style: TextStyle(fontSize: 14)),

            SizedBox(height: 12),

            // Price + Discount
            Row(
              children: [
                Text(
                  "₹349",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  product['price'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "15% OFF",
                    style: TextStyle(fontSize: 12, color: Colors.teal),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            Text(
              "Helps regulate sleep cycles, supports relaxation.",
              style: TextStyle(fontSize: 14),
            ),

            if (product['rx'])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Prescription required for this product",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),

            if (product['rx'])
              GestureDetector(
                onTap: () {
                  // TODO: Add File Picker here
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file),
                      SizedBox(width: 8),
                      Text("Upload Prescription"),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),

            // Rating + Reviews
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star_half, color: Colors.amber, size: 20),
                SizedBox(width: 6),
                Text("4.6", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text("(120 Reviews)", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Spacer(),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.colorIntroBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: AppColor.white),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.colorIntroBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Buy Now",
                      style: TextStyle(color: AppColor.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
