import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
abstract class AuthRepository {
  Future<Result<void, Failure>> signIn(String email, String password);
  Future<Result<void, Failure>> signUp({
    required String fullName, required String email, required String phone,
    required String password, required String confirmPassword, required String role,
  });
  Future<void> signOut();
  Future<Result<void, Failure>> sendPasswordResetEmail(String email);
  Future<Result<void, Failure>> updatePassword(String newPassword);
  Future<Result<Map<String, dynamic>, Failure>> getCurrentProfile();
}


