
class MaintenanceRequestModel {
  final String id; final String propertyId; final String tenantId; final String? assignedManagerId;
  final String title; final String description; final String priority; final String status;
  final DateTime createdAt; final DateTime updatedAt;
  const MaintenanceRequestModel({required this.id, required this.propertyId, required this.tenantId,
    this.assignedManagerId, required this.title, required this.description,
    required this.priority, required this.status, required this.createdAt, required this.updatedAt});
  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> j) => MaintenanceRequestModel(
    id: j['id'] as String, propertyId: j['property_id'] as String, tenantId: j['tenant_id'] as String,
    assignedManagerId: j['assigned_manager_id'] as String?,
    title: j['title'] as String, description: j['description'] as String,
    priority: j['priority'] as String, status: j['status'] as String,
    createdAt: DateTime.parse(j['created_at'] as String), updatedAt: DateTime.parse(j['updated_at'] as String),
  );
}
