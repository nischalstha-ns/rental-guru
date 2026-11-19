
class ProfileModel {
  final String id; final String fullName; final String? phone; final String? avatarPath;
  final String role; final String verificationStatus; final String accountStatus;
  final DateTime createdAt; final DateTime updatedAt;
  const ProfileModel({required this.id, required this.fullName, this.phone, this.avatarPath,
    required this.role, required this.verificationStatus, required this.accountStatus,
    required this.createdAt, required this.updatedAt});
  factory ProfileModel.fromJson(Map<String, dynamic> j) => ProfileModel(
    id: j['id'] as String, fullName: j['full_name'] as String, phone: j['phone'] as String?,
    avatarPath: j['avatar_path'] as String?, role: j['role'] as String,
    verificationStatus: j['verification_status'] as String, accountStatus: j['account_status'] as String,
    createdAt: DateTime.parse(j['created_at'] as String), updatedAt: DateTime.parse(j['updated_at'] as String),
  );
  Map<String, dynamic> toJson() => {'id': id, 'full_name': fullName, 'phone': phone, 'avatar_path': avatarPath, 'role': role, 'verification_status': verificationStatus, 'account_status': accountStatus, 'created_at': createdAt.toIso8601String(), 'updated_at': updatedAt.toIso8601String()};
}
