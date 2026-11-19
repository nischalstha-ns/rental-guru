
class RentalApplicationModel {
  final String id; final String propertyId; final String tenantId; final String? message;
  final DateTime? preferredMoveInDate; final String status;
  final String? reviewedBy; final DateTime? reviewedAt; final DateTime createdAt; final DateTime updatedAt;
  const RentalApplicationModel({required this.id, required this.propertyId, required this.tenantId,
    this.message, this.preferredMoveInDate, required this.status, this.reviewedBy, this.reviewedAt,
    required this.createdAt, required this.updatedAt});
  factory RentalApplicationModel.fromJson(Map<String, dynamic> j) => RentalApplicationModel(
    id: j['id'] as String, propertyId: j['property_id'] as String, tenantId: j['tenant_id'] as String,
    message: j['message'] as String?, preferredMoveInDate: j['preferred_move_in_date'] != null ? DateTime.parse(j['preferred_move_in_date']) : null,
    status: j['status'] as String, reviewedBy: j['reviewed_by'] as String?,
    reviewedAt: j['reviewed_at'] != null ? DateTime.parse(j['reviewed_at']) : null,
    createdAt: DateTime.parse(j['created_at']), updatedAt: DateTime.parse(j['updated_at']),
  );
}
