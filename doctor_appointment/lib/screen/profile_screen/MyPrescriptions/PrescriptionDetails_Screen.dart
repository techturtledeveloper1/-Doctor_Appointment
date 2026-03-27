import 'package:doctor_appointment/APIService/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:doctor_appointment/ReusableWidget/app_color.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  final String prescriptionId;

  const PrescriptionDetailsScreen({Key? key, required this.prescriptionId})
    : super(key: key);

  @override
  State<PrescriptionDetailsScreen> createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  Map<String, dynamic>? prescription;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPrescriptionDetails();
  }

  Future<void> _loadPrescriptionDetails() async {
    try {
      var response = await ApiService().callViewPrescriptionDetailsApi(
        widget.prescriptionId,
      );

      if (response != null) {
        setState(() {
          prescription = Map<String, dynamic>.from(response);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load prescription details';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading prescription: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          "Prescription Details",
          style: TextStyle(color: AppColor.white, fontSize: 20),
        ),
        backgroundColor: AppColor.colorPrimary,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColor.white),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: AppColor.white),
            onPressed: () {
              _downloadPrescription();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadPrescriptionDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (prescription == null) {
      return const Center(child: Text('No prescription data found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Prescription",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            prescription!['status'],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _getStatusColor(prescription!['status']),
                          ),
                        ),
                        child: Text(
                          _capitalizeFirst(
                            prescription!['status'] ?? 'Unknown',
                          ),
                          style: TextStyle(
                            color: _getStatusColor(prescription!['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.person,
                    "Doctor",
                    prescription!['doctor']?['fullName'] ?? 'Not specified',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.calendar_today,
                    "Prescribed Date",
                    _formatDate(prescription!['prescribedAt']),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.calendar_today,
                    "Follow-up Date",
                    _formatDate(prescription!['followUpDate']),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.person,
                    "Patient",
                    prescription!['patient']?['fullName'] ?? 'Not specified',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.phone,
                    "Patient Phone",
                    prescription!['patient']?['phone']?.toString() ??
                        'Not specified',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Medicines Section
          Text(
            "Prescribed Medicines",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.colorIntroBG,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildMedicinesList(),
            ),
          ),
          const SizedBox(height: 20),

          // Instructions Section
          Text(
            "Doctor's Notes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.colorIntroBG,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescription!['notes'] ?? 'No additional notes provided',
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorIntroBG,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _orderAllMedicines();
                  },
                  child: const Text(
                    "Order All Medicines",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.colorIntroBG,
                    side: BorderSide(color: AppColor.colorIntroBG),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _sharePrescription();
                  },
                  child: const Text("Share", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicinesList() {
    final medicines = prescription!['medicines'] as List?;

    if (medicines == null || medicines.isEmpty) {
      return const Text(
        "No medicines prescribed",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: medicines.map((medicine) {
        final med = Map<String, dynamic>.from(medicine);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.medical_services,
                        color: AppColor.colorIntroBG,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          med['name'] ?? 'Unknown Medicine',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMedicineDetail("Dosage", med['dosage']),
                  _buildMedicineDetail("Frequency", med['frequency']),
                  _buildMedicineDetail("Duration", med['duration']),
                  if (med['instructions'] != null &&
                      med['instructions'].isNotEmpty)
                    _buildMedicineDetail("Instructions", med['instructions']),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicineDetail(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 4),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Not specified';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _downloadPrescription() {
    print("Downloading prescription: ${prescription?['_id']}");
    // Implement download logic
  }

  void _orderAllMedicines() {
    print("Ordering all medicines for prescription: ${prescription?['_id']}");
    // Implement order all medicines logic
  }

  void _sharePrescription() {
    print("Sharing prescription: ${prescription?['_id']}");
    // Implement share logic
  }
}
