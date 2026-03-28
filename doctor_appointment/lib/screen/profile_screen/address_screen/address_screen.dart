import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/ReusableWidget/app_button.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';
import 'package:doctor_appointment/screen/profile_screen/address_screen/add_edit_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  List<dynamic> addresses = [];
  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    setState(() {
      isLoading = true;
    });

    var response = await ApiService().callViewAddressDetailsApi();

    if (response != null && response['success'] == true) {
      setState(() {
        addresses = response['data'] ?? [];

        int defaultIndex = addresses.indexWhere((e) => e['isDefault'] == true);

        if (defaultIndex != -1) {
          final defaultItem = addresses[defaultIndex];

          addresses.removeAt(defaultIndex);
          addresses.insert(0, defaultItem);

          selectedIndex = 0;
        } else if (addresses.isNotEmpty) {
          selectedIndex = 0;
        }

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("Failed to load addresses");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "My Addresses",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.white),
        backgroundColor: AppColor.colorPrimary,
      ),
      body: isLoading ? _buildLoadingState() : _buildAddressList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.colorPrimary,
        child: Icon(Icons.add, color: AppColor.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddEditAddressScreen(onAddressSaved: _fetchAddresses),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColor.colorIntroBG),
      ),
    );
  }

  Widget _buildAddressList() {
    return addresses.isEmpty ? _buildEmptyState() : _buildAddressesList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 20),
            Text(
              "No Address Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You haven’t added any address yet.\nTap + button to add a new address.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesList() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchAddresses,
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _buildAddressCard(address, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    final bool isDefault = address['isDefault'] == true;
    final bool isSelected = selectedIndex == index;
    IconData icon = Icons.location_on;

    if ((address['name'] ?? "").toLowerCase() == "home") {
      icon = Icons.home;
    } else if ((address['name'] ?? "").toLowerCase() == "work") {
      icon = Icons.work;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          final selectedItem = addresses[index];

          addresses.removeAt(index);

          addresses.insert(0, selectedItem);

          selectedIndex = 0;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColor.colorPrimary : AppColor.grey50,
            width: isSelected ? 2 : 1,
          ),

          boxShadow: [
            if (isSelected)
              BoxShadow(color: AppColor.colorIntroBG, blurRadius: 4),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address['fullName'] ?? "UserName",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      if (isSelected) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.colorPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Selected",
                            style: TextStyle(
                              color: AppColor.colorPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditAddressScreen(
                            address: address,
                            onAddressSaved: _fetchAddresses,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),

                      child: Icon(Icons.edit, size: 20, color: Colors.black87),
                    ),
                  ),
                  if (!isSelected) ...[
                    GestureDetector(
                      onTap: () => _deleteAddress(address['_id'], index),

                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.delete, size: 20, color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),

              Text(
                address['addressLine1'] ?? '',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),

              if (address['addressLine2'] != null &&
                  address['addressLine2'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    address['addressLine2'],
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),

              SizedBox(height: 4),

              Text(
                "${address['city']}, ${address['state']} ${address['postalCode']}",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),

              Text(
                address['country'] ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),

              if (address['landmark'] != null && address['landmark'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Landmark: ${address['landmark']}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

              SizedBox(height: 10),

              Row(
                children: [
                  /// PHONE (LEFT)
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.blue),
                      SizedBox(width: 4),
                      Text(
                        address['phone'] ?? '',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  Spacer(),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColor.colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 15, color: AppColor.colorPrimary),
                        SizedBox(width: 5),
                        Text(
                          address['name'] ?? "Address",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAddress(String addressId, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.white,
        title: Text("Delete Address"),
        content: Text("Are you sure you want to delete this address?"),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => Navigator.pop(context),
                  text: "Cancel",
                  backgroundColor: AppColor.white,

                  textStyle: TextStyle(
                    color: AppColor.colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    side: BorderSide(color: AppColor.colorPrimary),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _performDeleteAddress(addressId, index);
                  },
                  text: "Delete",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteAddress(String addressId, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      _showSnackBar("Authentication error");
      return;
    }

    var response = await ApiService().callRemoveAddressApi(addressId, token);

    if (response['success'] == true) {
      setState(() {
        addresses.removeAt(index);
      });
      _showSnackBar("Address deleted successfully!");
    } else {
      _showSnackBar(response['message'] ?? "Failed to delete address");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.toLowerCase().contains("success")
            ? Colors.green
            : Colors.red,
      ),
    );
  }
}
