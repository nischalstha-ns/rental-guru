import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/account_status_screen.dart';
import '../../features/dashboard/tenant_dashboard_screen.dart';
import '../../features/dashboard/landlord_dashboard_screen.dart';
import '../../features/dashboard/manager_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/settings_screen.dart';
import '../../features/notifications_screen.dart';
import '../../features/properties/presentation/screens/property_listing_screen.dart';
import '../../features/properties/presentation/screens/property_detail_screen.dart';
import '../../features/verification/presentation/screens/intro_screen.dart';
import '../../features/verification/presentation/screens/document_type_screen.dart';
import '../../features/verification/presentation/screens/document_front_screen.dart';
import '../../features/verification/presentation/screens/document_back_screen.dart';
import '../../features/verification/presentation/screens/face_capture_screen.dart';
import '../../features/verification/presentation/screens/review_screen.dart';
import '../../features/verification/presentation/screens/status_screen.dart';
import '../../features/applications/presentation/screens/application_form_screen.dart';
import '../../features/applications/presentation/screens/my_applications_screen.dart';
import '../../features/leases/presentation/screens/lease_details_screen.dart';
import '../../features/payments/presentation/screens/payment_history_screen.dart';
import '../../features/maintenance/presentation/screens/maintenance_list_screen.dart';
import '../../features/maintenance/presentation/screens/create_maintenance_screen.dart';
import '../../features/admin/presentation/screens/user_management_screen.dart';
import '../../features/admin/presentation/screens/verification_queue_screen.dart';
import '../../features/admin/presentation/screens/property_approval_screen.dart';
import '../../features/admin/presentation/screens/audit_log_screen.dart';
import 'route_names.dart';

class AppRouter {
  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: RouteName.splash,
      redirect: (context, state) {
        final authState = ref.read(authStateProvider).value;
        if (authState == null) return RouteName.login;
        final isLoggedIn = authState.user != null;
        final isPublic = [RouteName.splash, RouteName.login, RouteName.register, RouteName.forgotPassword, RouteName.resetPassword].contains(state.matchedLocation);
        final isAccountSuspended = authState.accountStatus == 'suspended';
        if (!isLoggedIn && !isPublic) return RouteName.login;
        if (isLoggedIn && isPublic) return RouteName.dashboard;
        if (isLoggedIn && isAccountSuspended) return RouteName.accountStatus;
        if (isLoggedIn && authState.role == 'admin') return RouteName.adminDashboard;
        if (isLoggedIn && authState.role == 'landlord') return RouteName.landlordDashboard;
        if (isLoggedIn && authState.role == 'property_manager') return RouteName.managerDashboard;
        if (isLoggedIn) return RouteName.dashboard;
        return null;
      },
      routes: [
        GoRoute(path: RouteName.splash, builder: (_, __) => const SplashScreen()),
        GoRoute(path: RouteName.login, builder: (_, __) => const LoginScreen()),
        GoRoute(path: RouteName.register, builder: (_, __) => const RegisterScreen()),
        GoRoute(path: RouteName.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
        GoRoute(path: RouteName.resetPassword, builder: (_, __) => const ResetPasswordScreen()),
        GoRoute(path: RouteName.accountStatus, builder: (_, __) => const AccountStatusScreen()),
        GoRoute(path: RouteName.dashboard, builder: (_, __) => const TenantDashboardScreen()),
        GoRoute(path: RouteName.landlordDashboard, builder: (_, __) => const LandlordDashboardScreen()),
        GoRoute(path: RouteName.managerDashboard, builder: (_, __) => const ManagerDashboardScreen()),
        GoRoute(path: RouteName.adminDashboard, builder: (_, __) => const AdminDashboardScreen()),
        GoRoute(path: RouteName.settings, builder: (_, __) => const SettingsScreen()),
        GoRoute(path: RouteName.notifications, builder: (_, __) => const NotificationsScreen()),
        GoRoute(path: RouteName.propertyListing, builder: (_, __) => const PropertyListingScreen()),
        GoRoute(path: RouteName.propertyDetail, builder: (_, state) => PropertyDetailScreen(propertyId: state.pathParameters['id']!)),
        GoRoute(path: RouteName.verificationIntro, builder: (_, __) => const VerificationIntroScreen()),
        GoRoute(path: RouteName.documentTypeSelect, builder: (_, __) => const DocumentTypeScreen()),
        GoRoute(path: RouteName.documentFrontUpload, builder: (_, __) => const DocumentFrontScreen()),
        GoRoute(path: RouteName.documentBackUpload, builder: (_, __) => const DocumentBackScreen()),
        GoRoute(path: RouteName.faceCapture, builder: (_, __) => const FaceCaptureScreen()),
        GoRoute(path: RouteName.reviewSubmission, builder: (_, __) => const ReviewSubmissionScreen()),
        GoRoute(path: RouteName.verificationStatus, builder: (_, __) => const VerificationStatusScreen()),
        GoRoute(path: RouteName.applicationForm, builder: (_, __) => const ApplicationFormScreen()),
        GoRoute(path: RouteName.myApplications, builder: (_, __) => const MyApplicationsScreen()),
        GoRoute(path: RouteName.leaseDetails, builder: (_, state) => LeaseDetailsScreen(id: state.pathParameters['id']!)),
        GoRoute(path: RouteName.paymentHistory, builder: (_, __) => const PaymentHistoryScreen()),
        GoRoute(path: RouteName.maintenanceList, builder: (_, __) => const MaintenanceListScreen()),
        GoRoute(path: RouteName.createMaintenance, builder: (_, __) => const CreateMaintenanceScreen()),
        GoRoute(path: RouteName.userManagement, builder: (_, __) => const UserManagementScreen()),
        GoRoute(path: RouteName.verificationQueue, builder: (_, __) => const VerificationQueueScreen()),
        GoRoute(path: RouteName.propertyApprovalQueue, builder: (_, __) => const PropertyApprovalScreen()),
        GoRoute(path: RouteName.auditLogViewer, builder: (_, __) => const AuditLogScreen()),
      ],
    );
  }
}