import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/models/auth_response.dart';
import '../repositories/auth_repository.dart';



class AuthState {
  final User? user;
  final String? role;
  final String? verificationStatus;
  final String? accountStatus;
  const AuthState({this.user, this.role, this.verificationStatus, this.accountStatus});
}

final authStateProvider = FutureProvider<AuthState>((ref) async {
  final session = SupabaseService.auth.currentSession;
  if (session == null) return const AuthState();
  final uid = session.user.id;
  final profiles = await SupabaseService.client.from('profiles').select().eq('id', uid).single();
  return AuthState(
    user: session.user,
    role: profiles['role'] as String?,
    verificationStatus: profiles['verification_status'] as String?,
    accountStatus: profiles['account_status'] as String?,
  );
});

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Result<void, Failure>> signIn(String email, String password) async {
    try {
      await SupabaseService.auth.signInWithPassword(password: password, email: email);
      return const Result.success(null);
    } catch (e, st) {
      final failure = ErrorMapper.mapError(e, st);
      return Result.failure(failure);
    }
  }

  @override
  Future<Result<void, Failure>> signUp({
    required String fullName, required String email, required String phone,
    required String password, required String confirmPassword, required String role,
  }) async {
    if (password != confirmPassword) return Result.failure(Failure.validation({'confirmPassword': 'Passwords do not match'}));
    try {
      final res = await SupabaseService.auth.signUp(email: email, password: password);
      if (res.user == null) return Result.failure(Failure.auth('Registration failed.'));
      await SupabaseService.client.from('profiles').insert({
        'id': res.user!.id, 'full_name': fullName, 'phone': phone,
        'role': role, 'verification_status': 'not_submitted', 'account_status': 'active',
      });
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(ErrorMapper.mapError(e, st));
    }
  }

  @override
  Future<void> signOut() async => await SupabaseService.auth.signOut();

  @override
  Future<Result<void, Failure>> sendPasswordResetEmail(String email) async {
    try {
      await SupabaseService.auth.resetPasswordForEmail(email);
      return const Result.success(null);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  @override
  Future<Result<void, Failure>> updatePassword(String newPassword) async {
    try {
      await SupabaseService.auth.updateUser(UserAttributes(password: newPassword));
      return const Result.success(null);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  @override
  Future<Result<Map<String, dynamic>, Failure>> getCurrentProfile() async {
    try {
      final uid = SupabaseService.currentUser?.id;
      if (uid == null) return Result.failure(const Failure.auth('Not authenticated'));
      final p = await SupabaseService.client.from('profiles').select().eq('id', uid).single();
      return Result.success(p);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);


