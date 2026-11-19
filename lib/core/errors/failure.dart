import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Sealed representation of all possible failure outcomes.
/// Used as the error type in Result-pattern repositories.
@freezed
class Failure with _$Failure {
  const factory Failure.auth(String message) = AuthFailure;
  const factory Failure.permission(String message) = PermissionFailure;
  const factory Failure.upload(String message) = UploadFailure;
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.notFound(String message) = NotFoundFailure;
  const factory Failure.validation(Map<String, String> fieldErrors) = ValidationFailure;
  const factory Failure.database(String message, {String? code}) = DatabaseFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}