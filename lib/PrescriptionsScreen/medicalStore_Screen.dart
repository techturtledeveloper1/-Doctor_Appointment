import 'package:flutter/material.dart';

import '../HomeScreen/OrderMedicineScreen/MedicinePayment_Screen.dart';
import '../Utils/ColorConstant.dart';

// ----------------- Dummy Data -----------------
// ----------------- Dummy Data -----------------
class MedicalStore {
  final String name;
  final String doctor;
  final String image;
  final List<Medicine> medicines;

  MedicalStore({
    required this.name,
    required this.doctor,
    required this.image,
    required this.medicines,
  });
}

class Medicine {
  final String name;
  final double price;
  final String image;

  Medicine({required this.name, required this.price,required this.image});
}

List<MedicalStore> stores = [
  MedicalStore(
    name: "City Medical Store",
    doctor: "Dr. Sharma",
    image: "https://img.freepik.com/free-photo/pharmacy-store-interior_23-2149175332.jpg",
    medicines: [
      Medicine(
        name: "Paracetamol",
        price: 30,
        image: "assets/Images/Paracetamol.png",
      ),
      Medicine(name: "Amoxicillin", price: 50,image: "assets/Images/Amoxicillin.png" ),
      Medicine(name: "Vitamin C", price: 30,image: "assets/Images/VitaminC.png",),
      Medicine(name: "Cough Syrup", price: 80,image: "assets/Images/CoughSyrup.png",),
      Medicine(name: "Pain Relief Gel", price: 60,image: "assets/Images/PainReliefGel.png",),
      Medicine(name: "Vitamin D", price: 40,image: "assets/Images/VitaminD.png",),
      Medicine(name: "Antacid Tablets", price: 25,image: "assets/Images/AntacidTablets.png",),
      Medicine(name: "Blood Pressure Pills", price: 120,image: "assets/Images/BloodPressurePills.png",),
      Medicine(name: "Glucose Powder", price: 35,image: "assets/Images/GlucosePowder.png",),
    ],
  ),
  MedicalStore(
    name: "Green Life Pharmacy",
    doctor: "Dr. Patel",
    image: "https://img.freepik.com/free-photo/medicine-drug-store_23-2148884935.jpg",
    medicines: [
      Medicine(
        name: "Paracetamol",
        price: 30,
        image: "assets/Images/Paracetamol.png",
      ),
      Medicine(name: "Amoxicillin", price: 50,image: "assets/Images/Amoxicillin.png" ),
      Medicine(name: "Vitamin C", price: 30,image: "assets/Images/VitaminC.png",),
      Medicine(name: "Cough Syrup", price: 80,image: "assets/Images/CoughSyrup.png",),
      Medicine(name: "Pain Relief Gel", price: 60,image: "assets/Images/PainReliefGel.png",),
      Medicine(name: "Vitamin D", price: 40,image: "assets/Images/VitaminD.png",),
      Medicine(name: "Antacid Tablets", price: 25,image: "assets/Images/AntacidTablets.png",),
      Medicine(name: "Blood Pressure Pills", price: 120,image: "assets/Images/BloodPressurePills.png",),
      Medicine(name: "Glucose Powder", price: 35,image: "assets/Images/GlucosePowder.png",),
    ],
  ),
  MedicalStore(
    name: "Wellness Chemist",
    doctor: "Dr. Mehta",
    image: "https://img.freepik.com/free-photo/modern-pharmacy-interior_23-2149175345.jpg",
    medicines: [
      Medicine(
        name: "Paracetamol",
        price: 30,
        image: "assets/Images/Paracetamol.png",
      ),
      Medicine(name: "Amoxicillin", price: 50,image: "assets/Images/Amoxicillin.png" ),
      Medicine(name: "Vitamin C", price: 30,image: "assets/Images/VitaminC.png",),
      Medicine(name: "Cough Syrup", price: 80,image: "assets/Images/CoughSyrup.png",),
      Medicine(name: "Pain Relief Gel", price: 60,image: "assets/Images/PainReliefGel.png",),
      Medicine(name: "Vitamin D", price: 40,image: "assets/Images/VitaminD.png",),
      Medicine(name: "Antacid Tablets", price: 25,image: "assets/Images/AntacidTablets.png",),
      Medicine(name: "Blood Pressure Pills", price: 120,image: "assets/Images/BloodPressurePills.png",),
      Medicine(name: "Glucose Powder", price: 35,image: "assets/Images/GlucosePowder.png",),
    ],
  ),
  MedicalStore(
    name: "Apollo Pharmacy",
    doctor: "Dr. Reddy",
    image: "https://img.freepik.com/free-photo/pharmacy-interior-blurred-background_1258-83046.jpg",
    medicines: [
      Medicine(
        name: "Paracetamol",
        price: 30,
        image: "assets/Images/Paracetamol.png",
      ),
      Medicine(name: "Amoxicillin", price: 50,image: "assets/Images/Amoxicillin.png" ),
      Medicine(name: "Vitamin C", price: 30,image: "assets/Images/VitaminC.png",),
      Medicine(name: "Cough Syrup", price: 80,image: "assets/Images/CoughSyrup.png",),
      Medicine(name: "Pain Relief Gel", price: 60,image: "assets/Images/PainReliefGel.png",),
      Medicine(name: "Vitamin D", price: 40,image: "assets/Images/VitaminD.png",),
      Medicine(name: "Antacid Tablets", price: 25,image: "assets/Images/AntacidTablets.png",),
      Medicine(name: "Blood Pressure Pills", price: 120,image: "assets/Images/BloodPressurePills.png",),
      Medicine(name: "Glucose Powder", price: 35,image: "assets/Images/GlucosePowder.png",),
    ],
  ),
  MedicalStore(
    name: "Health Plus Store",
    doctor: "Dr. Gupta",
    image: "https://img.freepik.com/free-photo/interior-modern-pharmacy_23-2149175347.jpg",
    medicines: [
      Medicine(
        name: "Paracetamol",
        price: 30,
        image: "assets/Images/Paracetamol.png",
      ),
      Medicine(name: "Amoxicillin", price: 50,image: "assets/Images/Amoxicillin.png" ),
      Medicine(name: "Vitamin C", price: 30,image: "assets/Images/VitaminC.png",),
      Medicine(name: "Cough Syrup", price: 80,image: "assets/Images/CoughSyrup.png",),
      Medicine(name: "Pain Relief Gel", price: 60,image: "assets/Images/PainReliefGel.png",),
      Medicine(name: "Vitamin D", price: 40,image: "assets/Images/VitaminD.png",),
      Medicine(name: "Antacid Tablets", price: 25,image: "assets/Images/AntacidTablets.png",),
      Medicine(name: "Blood Pressure Pills", price: 120,image: "assets/Images/BloodPressurePills.png",),
      Medicine(name: "Glucose Powder", price: 35,image: "assets/Images/GlucosePowder.png",),
    ],
  ),
  MedicalStore(
    name: "Care & Cure Pharmacy",
    doctor: "Dr. Desai",
    image: "https://img.freepik.com/free-photo/pharmacy-shelves-drugstore_23-2148884925.jpg",
    medicines: [
      Medicine(
        name: "Paracetamol",
        price: 30,
        image: "assets/Images/Paracetamol.png",
      ),
      Medicine(name: "Amoxicillin", price: 50,image: "assets/Images/Amoxicillin.png" ),
      Medicine(name: "Vitamin C", price: 30,image: "assets/Images/VitaminC.png",),
      Medicine(name: "Cough Syrup", price: 80,image: "assets/Images/CoughSyrup.png",),
      Medicine(name: "Pain Relief Gel", price: 60,image: "assets/Images/PainReliefGel.png",),
      Medicine(name: "Vitamin D", price: 40,image: "assets/Images/VitaminD.png",),
      Medicine(name: "Antacid Tablets", price: 25,image: "assets/Images/AntacidTablets.png",),
      Medicine(name: "Blood Pressure Pills", price: 120,image: "assets/Images/BloodPressurePills.png",),
      Medicine(name: "Glucose Powder", price: 35,image: "assets/Images/GlucosePowder.png",),
    ],
  ),
];


// ----------------- Medical Store List -----------------
class MedicalStoreListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      // appBar: AppBar(
      //   title: Text("Medical Stores",style: TextStyle(color: ColorConstant.colorIntroBG),),
      //   backgroundColor: ColorConstant.colorWhite,
      // ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: stores.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final store = stores[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicineListScreen(store: store),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        store.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Dr. ${store.doctor}",
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ----------------- Medicine List -----------------
class MedicineListScreen extends StatefulWidget {
  final MedicalStore store;
  const MedicineListScreen({Key? key, required this.store}) : super(key: key);

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  List<Medicine> cart = [];

  void addToCart(Medicine medicine) {
    setState(() {
      cart.add(medicine);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${medicine.name} added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        title: Text(widget.store.name,style: TextStyle(color: ColorConstant.colorIntroBG)),
        backgroundColor: ColorConstant.colorWhite,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart,color: ColorConstant.colorIntroBG),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MedicineCartScreen(cart: cart),
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text("${cart.length}",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
            ],
          )
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: widget.store.medicines.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final med = widget.store.medicines[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        med.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    med.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("₹${med.price}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.colorWhite),
                    onPressed: () => addToCart(med),
                    child: Text("Add"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ----------------- Cart Screen -----------------
// ----------------- Cart Screen -----------------
class MedicineCartScreen extends StatefulWidget {
  final List<Medicine> cart;

  const MedicineCartScreen({Key? key, required this.cart}) : super(key: key);

  @override
  State<MedicineCartScreen> createState() => _MedicineCartScreenState();
}

class _MedicineCartScreenState extends State<MedicineCartScreen> {
  Map<Medicine, int> quantities = {};

  @override
  void initState() {
    super.initState();
    // initialize quantities with 1 for each item
    for (var med in widget.cart) {
      quantities[med] = (quantities[med] ?? 0) + 1;
    }
  }

  void increaseQty(Medicine med) {
    setState(() {
      quantities[med] = (quantities[med] ?? 1) + 1;
    });
  }

  void decreaseQty(Medicine med) {
    setState(() {
      if ((quantities[med] ?? 1) > 1) {
        quantities[med] = quantities[med]! - 1;
      } else {
        quantities.remove(med);
      }
    });
  }

  double get subtotal {
    double sum = 0;
    quantities.forEach((med, qty) {
      sum += med.price * qty;
    });
    return sum;
  }

  double get deliveryCharge => subtotal > 0 ? 40 : 0;
  double get total => subtotal + deliveryCharge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      appBar: AppBar(
        title: Text("Your Cart", style: TextStyle(color: ColorConstant.colorIntroBG)),
        backgroundColor: ColorConstant.colorWhite,
      ),
      body: quantities.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quantities.length,
              itemBuilder: (context, index) {
                final med = quantities.keys.elementAt(index);
                final qty = quantities[med]!;
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 3,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        med.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(med.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("₹${med.price}"),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => decreaseQty(med),
                            ),
                            Text("$qty", style: TextStyle(fontSize: 16)),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () => increaseQty(med),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      "₹${(med.price * qty).toStringAsFixed(2)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal", style: TextStyle(fontSize: 16)),
                    Text("₹${subtotal.toStringAsFixed(2)}"),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery Charges", style: TextStyle(fontSize: 16)),
                    Text("₹${deliveryCharge.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(height: 20, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("₹${total.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.colorIntroBG,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final List<Map<String, dynamic>> orderMedicines = quantities.entries.map((entry) {
                      final med = entry.key;
                      final qty = entry.value;
                      return {
                        'name': med.name,
                        'mg': 500, // you can later make this dynamic if needed
                        'quantity': qty,
                        'price': med.price,
                      };
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicinePaymentScreen(
                          prescriptionId: "RX1G5F84",
                          medicines: orderMedicines,
                          deliveryAddress: "123 Main Street, City",
                          totalAmount: total,
                        ),
                      ),
                    );
                  },
                  child: Text("Proceed to Pay",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


// ----------------- Payment Success -----------------
class PaymentSuccessScreen extends StatelessWidget {
  final double total;
  const PaymentSuccessScreen({Key? key, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: ColorConstant.colorWhite, size: 100),
            SizedBox(height: 20),
            Text("Order Successful!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("You paid ₹$total",
                style: TextStyle(fontSize: 18, color: Colors.grey[700])),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: ColorConstant.colorWhite),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => MedicalStoreListScreen()),
                      (route) => false,
                );
              },
              child: Text("Back to Stores"),
            )
          ],
        ),
      ),
    );
  }
}

// // ----------------- Main -----------------
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: MedicalStoreListScreen(),
//   ));
// }
