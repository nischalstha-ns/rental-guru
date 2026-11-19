class AuthResponse {
  final bool success;
  final String? errorMessage;
  const AuthResponse({required this.success, this.errorMessage});
  factory AuthResponse.ok() => const AuthResponse(success: true);
  factory AuthResponse.fail(String msg) => AuthResponse(success: false, errorMessage: msg);
}
