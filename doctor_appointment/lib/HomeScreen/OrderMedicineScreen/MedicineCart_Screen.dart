import 'dart:convert';
import 'package:doctor_appointment/ApiService/ApiService.dart';
import 'package:doctor_appointment/Utils/ColorConstant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MedicinePayment_Screen.dart';

class MedicineCartScreen extends StatefulWidget {
  const MedicineCartScreen({super.key});

  @override
  State<MedicineCartScreen> createState() => _MedicineCartScreenState();
}

class _MedicineCartScreenState extends State<MedicineCartScreen> {
  List<Map<String, dynamic>> medicines = [];
  bool isLoading = true;
  double deliveryCharge = 20;

  @override
  void initState() {
    super.initState();
    fetchCartDetails();
  }

  Future<void> fetchCartDetails() async {
    var response = await ApiService().callViewCartDetailsApi();

    if (response != null && response['success'] == true) {
      List items = response['data']['items'];

      setState(() {
        medicines = items.map((item) {
          var med = item['medicine'];
          return {
            "id": med["_id"] ?? "",
            "name": med["name"] ?? "",
            "dosage": med["dosageForm"] ?? "",
            "image": (med["images"] != null && med["images"].isNotEmpty)
                ? med["images"][0]
                : "",
            "quantity": item["quantity"] ?? 1,
            "price": item["price"] ?? 0,
            "total": item["total"] ?? 0,
          };
        }).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // ✅ UPDATE CART API CALL - CORRECTED
  Future<void> updateCartQuantity(String medicineId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      print("Token Not Found");
      return;
    }

    // ✅ Use the correct API method
    var response = await ApiService().callUpdateCartItemApi(medicineId, quantity, token);

    if (response['success'] == true) {
      // ✅ Refresh Screen
      fetchCartDetails();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quantity updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Failed to update quantity")),
      );
      // ✅ Revert the quantity change if API call failed
      fetchCartDetails();
    }
  }

  // ✅ REMOVE ITEM API CALL
  Future<void> removeCartItem(String medicineId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      print("Token Not Found");
      return;
    }

    var response = await ApiService().callRemoveCartItemApi(medicineId, token);

    if (response['success'] == true) {
      // ✅ Refresh Screen
      fetchCartDetails();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Item removed successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Failed to remove item")),
      );
    }
  }

  // ✅ CLEAR CART API CALL
  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      print("Token Not Found");
      return;
    }

    var response = await ApiService().callClearCartApi(token);

    if (response['success'] == true) {
      setState(() {
        medicines.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Cart cleared successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Failed to clear cart")),
      );
    }
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
        iconTheme: IconThemeData(color: ColorConstant.colorIntroBG),
        backgroundColor: ColorConstant.colorWhite,
        actions: [
          // ✅ CLEAR CART BUTTON
          if (medicines.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Clear Cart"),
                    content: const Text("Are you sure you want to clear your entire cart?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          clearCart();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Clear Cart"),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : medicines.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "From Products Purchased",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.colorBlack,
                ),
              ),
            ),
            const SizedBox(height: 8),

            /// ✅ MEDICINE LIST
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Row(
                        children: [
                          /// Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: med["image"] != ""
                                ? Image.network(
                              med["image"],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(width: 12),

                          /// Name + Quantity
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${med['name']} (${med['dosage']})",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.colorBlack,
                                  ),
                                ),
                                Row(
                                  children: [
                                    /// ✅ DECREASE QUANTITY
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        if (med['quantity'] > 1) {
                                          setState(() {
                                            med['quantity']--;
                                          });

                                          updateCartQuantity(
                                              med["id"],
                                              med["quantity"]);
                                        }
                                      },
                                    ),

                                    Text(
                                      "${med['quantity']}",
                                      style: TextStyle(
                                          color: ColorConstant.colorBlack),
                                    ),

                                    /// ✅ INCREASE QUANTITY
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        setState(() {
                                          med['quantity']++;
                                        });

                                        updateCartQuantity(
                                            med["id"],
                                            med["quantity"]);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          /// Price & Remove
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹${med['price']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.colorBlack,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await removeCartItem(med["id"]);
                                },
                                child: Text(
                                  "Remove",
                                  style: TextStyle(
                                      color: ColorConstant.colorIntroBG),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// ✅ PRICE SUMMARY
            const Divider(),
            ListTile(
              title: const Text("Subtotal"),
              trailing: Text("₹${subtotal.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: const Text("Delivery Charge"),
              trailing: Text("₹${deliveryCharge.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "₹${total.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            /// ✅ ACTION BUTTONS
            Row(
              children: [
                // CLEAR CART BUTTON
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Clear Cart"),
                          content: const Text("Are you sure you want to clear your entire cart?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                clearCart();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Clear Cart"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(0, 50),
                    ),
                    child: const Text("Clear Cart"),
                  ),
                ),
                const SizedBox(width: 12),

                // PROCEED BUTTON
                Expanded(
                  child: ElevatedButton(
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
                    child: Text(
                      "Proceed",
                      style: TextStyle(color: ColorConstant.colorWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.colorIntroBG,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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