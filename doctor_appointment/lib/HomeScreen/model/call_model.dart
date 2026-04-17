// lib/models/call_model.dart
class CallModel {
  final String callId;
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String patientId;
  final String patientName;
  final String patientImage;
  final String appointmentId;
  final DateTime appointmentTime;
  final String callType; // 'video' or 'audio'
  final String
  status; // 'ringing', 'accepted', 'rejected', 'expired', 'cancelled'
  final DateTime initiatedAt;
  final DateTime? expiresAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;

  CallModel({
    required this.callId,
    required this.doctorId,
    required this.doctorName,
    this.doctorImage = '',
    required this.patientId,
    required this.patientName,
    this.patientImage = '',
    required this.appointmentId,
    required this.appointmentTime,
    required this.callType,
    required this.status,
    required this.initiatedAt,
    this.expiresAt,
    this.acceptedAt,
    this.rejectedAt,
  });

  factory CallModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CallModel(
      callId: id,
      doctorId: data['doctorId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      doctorImage: data['doctorImage'] ?? '',
      patientId: data['patientId'] ?? '',
      patientName: data['patientName'] ?? '',
      patientImage: data['patientImage'] ?? '',
      appointmentId: data['appointmentId'] ?? '',
      appointmentTime: (data['appointmentTime'] as dynamic).toDate(),
      callType: data['callType'] ?? 'video',
      status: data['status'] ?? 'ringing',
      initiatedAt: (data['initiatedAt'] as dynamic).toDate(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as dynamic).toDate()
          : null,
      acceptedAt: data['acceptedAt'] != null
          ? (data['acceptedAt'] as dynamic).toDate()
          : null,
      rejectedAt: data['rejectedAt'] != null
          ? (data['rejectedAt'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'patientId': patientId,
      'patientName': patientName,
      'patientImage': patientImage,
      'appointmentId': appointmentId,
      'appointmentTime': appointmentTime,
      'callType': callType,
      'status': status,
      'initiatedAt': initiatedAt,
      'expiresAt': expiresAt,
      'acceptedAt': acceptedAt,
      'rejectedAt': rejectedAt,
    };
  }
}
