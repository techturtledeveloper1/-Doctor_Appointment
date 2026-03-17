import 'package:flutter/material.dart';

class MyPrescriptionsScreen extends StatefulWidget {
  const MyPrescriptionsScreen({super.key});

  @override
  State<MyPrescriptionsScreen> createState() => _MyPrescriptionsScreenState();
}

class _MyPrescriptionsScreenState extends State<MyPrescriptionsScreen> {
  List<dynamic> prescriptions = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPrescriptions();
  }

  Future<void> _fetchPrescriptions() async {
    try {
      var response = await ApiService().callViewPrescriptionListApi();

      if (response != null && response['success'] == true) {
        setState(() {
          prescriptions = response['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Error fetching prescriptions: $e");
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day} ${_getMonthName(date.month)} ${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  MaterialColor _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'expired':
        return 'Expired';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "My Prescriptions",
          style: TextStyle(color: AppColor.colorIntroBG),
        ),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColor.colorIntroBG),
      ),
      body: isLoading
          ? _buildLoadingState()
          : hasError
          ? _buildErrorState()
          : prescriptions.isEmpty
          ? _buildEmptyState()
          : _buildPrescriptionsList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.colorIntroBG),
          ),
          SizedBox(height: 16),
          Text(
            "Loading your prescriptions...",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          SizedBox(height: 16),
          Text(
            "Failed to load prescriptions",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Please check your internet connection",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.colorIntroBG,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _fetchPrescriptions,
            child: Text("Try Again", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            "No Prescriptions Found",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your prescriptions will appear here",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsList() {
    return RefreshIndicator(
      onRefresh: _fetchPrescriptions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = prescriptions[index];
          final doctor = prescription['doctor'] ?? {};
          final medicines = prescription['medicines'] ?? [];
          final prescriptionId = prescription['_id'] ?? '';

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT SIDE: Prescription details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Name
                        Text(
                          "Dr. ${doctor['fullName'] ?? 'Unknown Doctor'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),

                        // Specialization
                        if (doctor['specialization'] != null)
                          Text(
                            doctor['specialization'] as String,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),

                        SizedBox(height: 8),

                        // Date and Status
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _formatDate(prescription['prescribedAt'] ?? ''),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4),

                        // Medicines count
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${medicines.length} medicine${medicines.length != 1 ? 's' : ''} prescribed",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Status
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              prescription['status'] ?? '',
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _getStatusColor(
                                prescription['status'] ?? '',
                              ),
                            ),
                          ),
                          child: Text(
                            _getStatusText(prescription['status'] ?? ''),
                            style: TextStyle(
                              color: _getStatusColor(
                                prescription['status'] ?? '',
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT SIDE: Action buttons
                  Column(
                    children: [
                      // View Button
                      InkWell(
                        onTap: () {
                          if (prescriptionId.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrescriptionDetailsScreen(
                                  prescriptionId: prescriptionId,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Unable to view prescription details",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: AppColor.colorIntroBG,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "View",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.colorIntroBG,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Download Button
                      InkWell(
                        onTap: () {
                          _downloadPrescription(prescription);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.download, color: AppColor.colorIntroBG),
                            SizedBox(height: 4),
                            Text(
                              "Download\nPDF",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.colorIntroBG,
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
          );
        },
      ),
    );
  }

  void _downloadPrescription(Map<String, dynamic> prescription) {
    // Implement download logic here
    final doctorName = prescription['doctor']?['fullName'] ?? 'Unknown Doctor';
    print("Downloading prescription from Dr. $doctorName");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Downloading prescription..."),
        backgroundColor: Colors.green,
      ),
    );
  }
}
