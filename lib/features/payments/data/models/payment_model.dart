
class PaymentModel {
  final String id; final String leaseId; final String tenantId;
  final num amount; final String paymentType; final DateTime dueDate;
  final DateTime? paidAt; final String paymentStatus; final String? transactionReference;
  final DateTime createdAt;
  const PaymentModel({required this.id, required this.leaseId, required this.tenantId,
    required this.amount, required this.paymentType, required this.dueDate,
    this.paidAt, required this.paymentStatus, this.transactionReference, required this.createdAt});
  factory PaymentModel.fromJson(Map<String, dynamic> j) => PaymentModel(
    id: j['id'] as String, leaseId: j['lease_id'] as String, tenantId: j['tenant_id'] as String,
    amount: j['amount'] as num, paymentType: j['payment_type'] as String,
    dueDate: DateTime.parse(j['due_date'] as String),
    paidAt: j['paid_at'] != null ? DateTime.parse(j['paid_at']) : null,
    paymentStatus: j['payment_status'] as String,
    transactionReference: j['transaction_reference'] as String?,
    createdAt: DateTime.parse(j['created_at'] as String),
  );
}
