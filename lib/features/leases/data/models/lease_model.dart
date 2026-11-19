
class LeaseModel {
  final String id; final String propertyId; final String tenantId; final String landlordId; final String? managerId;
  final DateTime? startDate; final DateTime? endDate; final num monthlyRent; final num securityDeposit;
  final String status; final String? leaseDocumentPath; final DateTime createdAt; final DateTime updatedAt;
  const LeaseModel({required this.id, required this.propertyId, required this.tenantId,
    required this.landlordId, this.managerId, this.startDate, this.endDate,
    required this.monthlyRent, required this.securityDeposit, required this.status,
    this.leaseDocumentPath, required this.createdAt, required this.updatedAt});
  factory LeaseModel.fromJson(Map<String, dynamic> j) => LeaseModel(
    id: j['id'] as String, propertyId: j['property_id'] as String, tenantId: j['tenant_id'] as String,
    landlordId: j['landlord_id'] as String, managerId: j['manager_id'] as String?,
    startDate: j['start_date'] != null ? DateTime.parse(j['start_date']) : null,
    endDate: j['end_date'] != null ? DateTime.parse(j['end_date']) : null,
    monthlyRent: j['monthly_rent'] as num, securityDeposit: j['security_deposit'] as num,
    status: j['status'] as String, leaseDocumentPath: j['lease_document_path'] as String?,
    createdAt: DateTime.parse(j['created_at']), updatedAt: DateTime.parse(j['updated_at']),
  );
}
