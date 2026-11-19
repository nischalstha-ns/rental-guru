
class UserDocumentModel {
  final String id; final String userId; final String documentType;
  final String? documentNumber; final String filePath; final String mimeType;
  final int fileSize; final String verificationStatus; final String? rejectionReason;
  final String? reviewedBy; final DateTime? reviewedAt; final DateTime createdAt; final DateTime updatedAt;
  const UserDocumentModel({required this.id, required this.userId, required this.documentType,
    this.documentNumber, required this.filePath, required this.mimeType,
    required this.fileSize, required this.verificationStatus, this.rejectionReason,
    this.reviewedBy, this.reviewedAt, required this.createdAt, required this.updatedAt});
  factory UserDocumentModel.fromJson(Map<String, dynamic> j) => UserDocumentModel(
    id: j['id'] as String, userId: j['user_id'] as String, documentType: j['document_type'] as String,
    documentNumber: j['document_number'] as String?, filePath: j['file_path'] as String,
    mimeType: j['mime_type'] as String, fileSize: (j['file_size'] as num).toInt(),
    verificationStatus: j['verification_status'] as String, rejectionReason: j['rejection_reason'] as String?,
    reviewedBy: j['reviewed_by'] as String?, reviewedAt: j['reviewed_at'] != null ? DateTime.parse(j['reviewed_at']) : null,
    createdAt: DateTime.parse(j['created_at']), updatedAt: DateTime.parse(j['updated_at']),
  );
}
