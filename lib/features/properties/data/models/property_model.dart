
class PropertyModel {
  final String id; final String landlordId; final String? assignedManagerId;
  final String title; final String? description; final String? propertyType;
  final String? addressLine; final String? city; final String? district; final String? province;
  final double? latitude; final double? longitude;
  final num monthlyRent; final num securityDeposit;
  final int? bedrooms; final int? bathrooms; final num? areaSqFt; final String? furnishingStatus;
  final String availabilityStatus; final String verificationStatus; final String? rejectionReason;
  final DateTime createdAt; final DateTime updatedAt;
  const PropertyModel({required this.id, required this.landlordId, this.assignedManagerId,
    required this.title, this.description, this.propertyType, this.addressLine, this.city,
    this.district, this.province, this.latitude, this.longitude,
    required this.monthlyRent, required this.securityDeposit,
    this.bedrooms, this.bathrooms, this.areaSqFt, this.furnishingStatus,
    required this.availabilityStatus, required this.verificationStatus,
    this.rejectionReason, required this.createdAt, required this.updatedAt});
  factory PropertyModel.fromJson(Map<String, dynamic> j) => PropertyModel(
    id: j['id'] as String, landlordId: j['landlord_id'] as String,
    assignedManagerId: j['assigned_manager_id'] as String?,
    title: j['title'] as String, description: j['description'] as String?,
    propertyType: j['property_type'] as String?, addressLine: j['address_line'] as String?,
    city: j['city'] as String?, district: j['district'] as String?, province: j['province'] as String?,
    latitude: j['latitude'] as double?, longitude: j['longitude'] as double?,
    monthlyRent: j['monthly_rent'] as num, securityDeposit: j['security_deposit'] as num,
    bedrooms: j['bedrooms'] as int?, bathrooms: j['bathrooms'] as int?,
    areaSqFt: j['area_sq_ft'] as num?, furnishingStatus: j['furnishing_status'] as String?,
    availabilityStatus: j['availability_status'] as String,
    verificationStatus: j['verification_status'] as String,
    rejectionReason: j['rejection_reason'] as String?,
    createdAt: DateTime.parse(j['created_at']), updatedAt: DateTime.parse(j['updated_at']),
  );
  Map<String, dynamic> toJson() => {
    'id': id, 'landlord_id': landlordId, 'assigned_manager_id': assignedManagerId,
    'title': title, 'description': description, 'property_type': propertyType,
    'address_line': addressLine, 'city': city, 'district': district, 'province': province,
    'latitude': latitude, 'longitude': longitude,
    'monthly_rent': monthlyRent, 'security_deposit': securityDeposit,
    'bedrooms': bedrooms, 'bathrooms': bathrooms, 'area_sq_ft': areaSqFt,
    'furnishing_status': furnishingStatus, 'availability_status': availabilityStatus,
    'verification_status': verificationStatus, 'rejection_reason': rejectionReason,
    'created_at': createdAt.toIso8601String(), 'updated_at': updatedAt.toIso8601String(),
  };
  PropertyModel copyWith({String? title, String? description, String? propertyType, String? addressLine,
    String? city, String? district, String? province, double? latitude, double? longitude,
    num? monthlyRent, num? securityDeposit, int? bedrooms, int? bathrooms, num? areaSqFt,
    String? furnishingStatus, String? availabilityStatus, String? verificationStatus, String? rejectionReason}) {
    return PropertyModel(
      id: id, landlordId: landlordId, assignedManagerId: assignedManagerId,
      title: title ?? this.title, description: description ?? this.description,
      propertyType: propertyType ?? this.propertyType, addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city, district: district ?? this.district, province: province ?? this.province,
      latitude: latitude ?? this.latitude, longitude: longitude ?? this.longitude,
      monthlyRent: monthlyRent ?? this.monthlyRent, securityDeposit: securityDeposit ?? this.securityDeposit,
      bedrooms: bedrooms ?? this.bedrooms, bathrooms: bathrooms ?? this.bathrooms,
      areaSqFt: areaSqFt ?? this.areaSqFt, furnishingStatus: furnishingStatus ?? this.furnishingStatus,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt, updatedAt: updatedAt,
    );
  }
  String? get address => addressLine;
}
