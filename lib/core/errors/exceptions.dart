/// Base exception for all domain-level failures in the app.
abstract class AppException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException($message)';
}

/// Thrown when authentication fails (wrong credentials, expired session, etc.).
class AuthException extends AppException {
  const AuthException({required super.message, super.originalError, super.stackTrace});
}

/// Thrown when a user attempts an operation they lack permission for.
class PermissionException extends AppException {
  const PermissionException({required super.message, super.originalError, super.stackTrace});
}

/// Thrown when a file upload fails or violates constraints.
class UploadException extends AppException {
  const UploadException({required super.message, super.originalError, super.stackTrace});
}

/// Thrown when the network is unavailable.
class NetworkException extends AppException {
  const NetworkException({required super.message, super.originalError, super.stackTrace});
}

/// Thrown when a Supabase query returns no results for a required entity.
class NotFoundException extends AppException {
  const NotFoundException({required super.message, super.originalError, super.stackTrace});
}

/// Thrown when a validation rule on form/data is violated.
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });
}

/// Thrown when a database operation is denied by RLS policies.
class DatabaseException extends AppException {
  final String? code;
  const DatabaseException({
    required super.message,
    this.code,
    super.originalError,
    super.stackTrace,
  });
}