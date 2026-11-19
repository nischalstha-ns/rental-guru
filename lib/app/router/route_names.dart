import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Route names used throughout the application.
abstract final class RouteName {
  RouteName._();

  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String accountStatus = '/account-status';

  // Verification
  static const String verificationIntro = '/verification/intro';
  static const String documentTypeSelect = '/verification/document-type';
  static const String documentFrontUpload = '/verification/document-front';
  static const String documentBackUpload = '/verification/document-back';
  static const String faceCapture = '/verification/face-capture';
  static const String reviewSubmission = '/verification/review';
  static const String verificationStatus = '/verification/status';

  // Shared
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  // Tenant
  static const String propertyListing = '/properties';
  static const String propertyDetail = '/properties/:id';
  static const String applicationForm = '/applications/new';
  static const String myApplications = '/my-applications';
  static const String leaseDetails = '/leases/:id';
  static const String paymentHistory = '/payments';
  static const String maintenanceList = '/maintenance';
  static const String createMaintenance = '/maintenance/new';

  // Landlord
  static const String landlordDashboard = '/landlord/dashboard';
  static const String myProperties = '/landlord/properties';
  static const String addProperty = '/landlord/properties/new';
  static const String editProperty = '/landlord/properties/:id/edit';
  static const String propertyImages = '/landlord/properties/:id/images';
  static const String propertyDocuments = '/landlord/properties/:id/documents';
  static const String applicationReview = '/landlord/applications/:id';
  static const String tenantList = '/landlord/tenants';
  static const String leaseManagement = '/landlord/leases';
  static const String paymentTracking = '/landlord/payments';
  static const String maintenanceManagement = '/landlord/maintenance';
  static const String assignManager = '/landlord/properties/:id/assign-manager';

  // Property Manager
  static const String managerDashboard = '/manager/dashboard';
  static const String assignedProperties = '/manager/properties';
  static const String managerTenantManagement = '/manager/tenants';
  static const String managerApplicationManagement = '/manager/applications';
  static const String managerLeaseManagement = '/manager/leases';
  static const String managerPaymentTracking = '/manager/payments';
  static const String managerPropertyInspection = '/manager/inspections';
  static const String managerMaintenanceManagement = '/manager/maintenance';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String userManagement = '/admin/users';
  static const String verificationQueue = '/admin/verifications';
  static const String verificationReview = '/admin/verifications/:id';
  static const String propertyApprovalQueue = '/admin/properties';
  static const String propertyReview = '/admin/properties/:id';
  static const String roleAssignment = '/admin/roles';
  static const String suspendedAccounts = '/admin/suspended';
  static const String auditLogViewer = '/admin/audit-logs';
}