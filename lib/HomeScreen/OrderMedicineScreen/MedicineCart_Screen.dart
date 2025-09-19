import 'package:doctor_appointment/Utils/ColorConstant.dart';
import 'package:flutter/material.dart';

import 'MedicinePayment_Screen.dart';

class MedicineCartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> medicines;
  final String prescriptionFileName;

  const MedicineCartScreen({
    super.key,
    required this.medicines,
    required this.prescriptionFileName,
  });

  @override
  State<MedicineCartScreen> createState() => _MedicineCartScreenState();
}

class _MedicineCartScreenState extends State<MedicineCartScreen> {
  late List<Map<String, dynamic>> medicines;

  double deliveryCharge = 20;

  @override
  void initState() {
    super.initState();
    medicines = widget.medicines.map((med) => Map<String, dynamic>.from(med)).toList();
  }

  double get subtotal {
    double sum = 0;
    for (var med in medicines) {
      sum += (med['price'] as num) * (med['quantity'] as num);
    }
    return sum.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    double total = subtotal + deliveryCharge;

    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Order Summary",
            style: TextStyle(color: ColorConstant.colorIntroBG),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PDF Upload Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.prescriptionFileName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "From Products Purchased",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                  color: ColorConstant.colorBlack
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Medicine List
            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final med = medicines[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Medicine Info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${med['name']} ${med['mg']} mg",
                                  style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstant.colorBlack)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  // Quantity controls
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        if (med['quantity'] > 1) med['quantity']--;
                                      });
                                    },
                                  ),
                                  Text("${med['quantity']}",style: TextStyle(color: ColorConstant.colorBlack),),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      setState(() {
                                        med['quantity']++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Price & Remove
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("₹${med['price']}", style: TextStyle(fontWeight: FontWeight.bold,color: ColorConstant.colorBlack)),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    medicines.removeAt(index);
                                  });
                                },
                                child: Text("Remove",style: TextStyle(color: ColorConstant.colorIntroBG),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Address
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on),
              title: const Text("123 Main St, City, State 12345"),
              trailing: TextButton(
                onPressed: () {},
                child: Text("Add New Address",style: TextStyle(color: ColorConstant.colorIntroBG),),
              ),
            ),

            const Divider(),

            // Price Summary
            ListTile(
              title: const Text("Subtotal"),
              trailing: Text("₹${subtotal.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: const Text("Delivery Charge"),
              trailing: Text("₹${deliveryCharge.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text("₹${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            // Proceed Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicinePaymentScreen(
                      prescriptionId: "RX1G5F84",
                      medicines: medicines,
                      deliveryAddress: "123 Main Street, City",
                      totalAmount: total,
                    ),
                  ),
                );
              },
              child: Text("Proceed",style: TextStyle(color: ColorConstant.colorWhite),),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.colorIntroBG,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
