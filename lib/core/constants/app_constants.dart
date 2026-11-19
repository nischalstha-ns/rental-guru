/// Application-wide constants used throughout the rental management system.
class AppConstants {
  AppConstants._();

  // ─── App Identity ───────────────────────────────────────────
  static const String appName = 'Rent Guru';
  static const String appTagline = 'Smart Rental Management';

  // ─── Storage Buckets ────────────────────────────────────────
  static const String bucketUserDocuments = 'user-documents';
  static const String bucketFaceVerification = 'face-verification';
  static const String bucketPropertyDocuments = 'property-documents';
  static const String bucketPropertyImages = 'property-images';
  static const String bucketLeaseDocuments = 'lease-documents';
  static const String bucketMaintenanceAttachments = 'maintenance-attachments';

  // ─── File Type Restrictions ────────────────────────────────
  static const List<String> allowedImageMimeTypes = [
    'image/jpeg', 'image/png', 'image/webp',
  ];
  static const List<String> allowedDocumentMimeTypes = [
    'application/pdf', 'image/jpeg', 'image/png',
  ];
  static const int maxUploadSizeBytes = 10 * 1024 * 1024;
  static const int maxPropertyImages = 20;
  static const int maxPropertyDocuments = 10;

  // ─── Role Constants ────────────────────────────────────────
  static const String roleTenant = 'tenant';
  static const String roleLandlord = 'landlord';
  static const String rolePropertyManager = 'property_manager';
  static const String roleAdmin = 'admin';

  static const Set<String> rolesRequiringVerification = {
    roleTenant, roleLandlord, rolePropertyManager,
  };

  // ─── Verification Status ───────────────────────────────────
  static const String verificationStatusNotSubmitted = 'not_submitted';
  static const String verificationStatusPending = 'pending';
  static const String verificationStatusApproved = 'approved';
  static const String verificationStatusRejected = 'rejected';

  // ─── Account Status ────────────────────────────────────────
  static const String accountStatusActive = 'active';
  static const String accountStatusSuspended = 'suspended';
  static const String accountStatusDeleted = 'deleted';

  // ─── Property Availability ─────────────────────────────────
  static const String availabilityAvailable = 'available';
  static const String availabilityOccupied = 'occupied';
  static const String availabilityUnavailable = 'unavailable';

  // ─── Property Verification ─────────────────────────────────
  static const String propertyVerificationDraft = 'draft';
  static const String propertyVerificationPending = 'pending';
  static const String propertyVerificationApproved = 'approved';
  static const String propertyVerificationRejected = 'rejected';

  // ─── Application / Lease / Payment Statuses ────────────────
  static const String applicationStatusPending = 'pending';
  static const String applicationStatusApproved = 'approved';
  static const String applicationStatusRejected = 'rejected';
  static const String applicationStatusWithdrawn = 'withdrawn';

  static const String leaseStatusDraft = 'draft';
  static const String leaseStatusActive = 'active';
  static const String leaseStatusExpired = 'expired';
  static const String leaseStatusTerminated = 'terminated';

  static const String paymentStatusPending = 'pending';
  static const String paymentStatusPaid = 'paid';
  static const String paymentStatusOverdue = 'overdue';
  static const String paymentStatusFailed = 'failed';

  // ─── Maintenance ───────────────────────────────────────────
  static const String maintenancePriorityLow = 'low';
  static const String maintenancePriorityMedium = 'medium';
  static const String maintenancePriorityHigh = 'high';
  static const String maintenancePriorityEmergency = 'emergency';

  static const String maintenanceStatusOpen = 'open';
  static const String maintenanceStatusAssigned = 'assigned';
  static const String maintenanceStatusInProgress = 'in_progress';
  static const String maintenanceStatusResolved = 'resolved';
  static const String maintenanceStatusClosed = 'closed';

  // ─── Pagination ────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ─── Face Verification ─────────────────────────────────────
  static const double faceMatchMinConfidence = 0.75;
  static const int maxFaceVerificationRetries = 3;

  // ─── Document Types ────────────────────────────────────────
  static const String docTypeNationalId = 'national_id';
  static const String docTypeCitizenshipFront = 'citizenship_front';
  static const String docTypeCitizenshipBack = 'citizenship_back';
  static const String docTypePassport = 'passport';
  static const String docTypeProfilePhoto = 'profile_photo';
  static const String docTypeLiveFacePhoto = 'live_face_photo';
  static const String docTypeLandlordIdentity = 'landlord_identity';
  static const String docTypePropertyManagerIdentity = 'property_manager_identity';
  static const String docTypeOther = 'other';

  // ─── Property Document Types ───────────────────────────────
  static const String propDocOwnershipCertificate = 'ownership_certificate';
  static const String propDocLandDocument = 'land_document';
  static const String propDocTaxReceipt = 'tax_receipt';
  static const String propDocBuildingPermit = 'building_permit';
  static const String propDocUtilityBill = 'utility_bill';
  static const String propDocPropertyIdentity = 'property_identity';
}