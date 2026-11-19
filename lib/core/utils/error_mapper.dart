import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../errors/exceptions.dart';
import '../errors/failure.dart';

/// Maps low-level errors into user-friendly [Failure] objects.
class ErrorMapper {
  const ErrorMapper._();

  /// Converts any thrown error into a [Failure].
  static Failure mapError(Object error, [StackTrace? stack]) {
    // Network / connectivity errors
    if (error is SocketException) {
      return const Failure.network('No internet connection. Please check your network settings.');
    }

    // Supabase-specific errors
    if (error is PostgrestException) {
      return _mapPostgrest(error);
    }
    if (error is gotrue.AuthException) {
      return _mapAuth(error);
    }
    if (error is StorageException) {
      return _mapStorage(error);
    }

    // Our own domain exceptions
    if (error is AppException) {
      return _fromAppException(error);
    }

    // Fallback
    return Failure.unknown('An unexpected error occurred. Please try again later.');
  }

  static Failure _mapPostgrest(PostgrestException e) {
    switch (e.code) {
      case '23505': // unique violation
        return Failure.validation({'form': 'A record with this value already exists.'});
      case '23503': // foreign key violation
        return const Failure.permission('Referenced entity not found.');
      case 'PGRST201': // denied by RLS
        return const Failure.permission('You do not have permission to perform this action.');
      default:
        return Failure.database(e.message, code: e.code);
    }
  }

  static Failure _mapAuth(gotrue.AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return const Failure.auth('Invalid email or password. Please try again.');
      case 'Email not confirmed':
        return const Failure.auth('Please verify your email address before signing in.');
      case 'User not found':
        return const Failure.auth('No account found with this email address.');
      case 'Invalid credentials':
        return const Failure.auth('Invalid email or password. Please try again.');
      case 'Invalid API key':
        return const Failure.unknown('Authentication service unavailable. Please contact support.');
      default:
        return Failure.auth(e.message);
    }
  }

  static Failure _mapStorage(StorageException e) {
    final statusCode = int.tryParse(e.statusCode ?? '');
    switch (statusCode) {
      case 403:
        return const Failure.permission('You do not have permission to upload this file.');
      case 404:
        return const Failure.notFound('Storage bucket not found.');
      case 413:
        return const Failure.upload('File exceeds the maximum allowed size of 10 MB.');
      default:
        return Failure.upload(e.message);
    }
  }

  static Failure _fromAppException(AppException e) {
    return switch (e) {
      AuthException() => Failure.auth(e.message),
      PermissionException() => Failure.permission(e.message),
      UploadException() => Failure.upload(e.message),
      NetworkException() => Failure.network(e.message),
      NotFoundException() => Failure.notFound(e.message),
      ValidationException(fieldErrors: final fields) when fields != null =>
        Failure.validation(fields),
      DatabaseException(code: final code) => Failure.database(e.message, code: code),
      _ => Failure.unknown(e.message),
    };
  }
}