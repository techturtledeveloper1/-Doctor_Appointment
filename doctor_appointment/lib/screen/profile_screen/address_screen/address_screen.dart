import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:doctor_appointment/Utils/AppColor.dart';
import 'package:doctor_appointment/screen/profile_screen/address_screen/update_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  List<dynamic> addresses = [];
  bool isLoading = true;

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
          style: TextStyle(color: AppColor.colorIntroBG),
        ),
        backgroundColor: AppColor.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.colorIntroBG),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!isLoading)
            IconButton(
              icon: Icon(Icons.add, color: AppColor.colorIntroBG),
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
        ],
      ),
      body: isLoading ? _buildLoadingState() : _buildAddressList(),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            "No Addresses Added",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add your first delivery address",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.colorIntroBG,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditAddressScreen(onAddressSaved: _fetchAddresses),
                ),
              );
            },
            child: Text(
              "Add Address",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
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
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.colorIntroBG,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditAddressScreen(onAddressSaved: _fetchAddresses),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  "Add New Address",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.colorIntroBG.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColor.colorIntroBG),
                  ),
                  child: Text(
                    address['name'] ?? 'Address',
                    style: TextStyle(
                      color: AppColor.colorIntroBG,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Edit Button
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: () {
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
                    ),
                    // Delete Button
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _deleteAddress(address['_id'], index),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              address['addressLine1'] ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (address['addressLine2'] != null &&
                address['addressLine2'].isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  address['addressLine2'],
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
            SizedBox(height: 4),
            Text(
              "${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['postalCode'] ?? ''}",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            SizedBox(height: 4),
            Text(
              address['country'] ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            if (address['landmark'] != null && address['landmark'].isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Landmark: ${address['landmark']}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  address['phone'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (address['isDefault'] == true) ...[
                  SizedBox(width: 16),
                  Icon(Icons.star, size: 14, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(
                    "Default Address",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAddress(String addressId, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Address"),
        content: Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await _performDeleteAddress(addressId, index);
            },
            child: Text("Delete"),
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
