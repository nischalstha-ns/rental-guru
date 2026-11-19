import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'dart:typed_data';
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/models/profile_model.dart';

class ProfileRepositoryImpl {
  Future<Result<ProfileModel, Failure>> getProfile(String userId) async {
    try {
      final data = await SupabaseService.client.from('profiles').select().eq('id', userId).single();
      return Result.success(ProfileModel.fromJson(data));
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  Future<Result<void, Failure>> updateProfile(String userId, Map<String, dynamic> updates) async {
    try {
      await SupabaseService.client.from('profiles').update(updates).eq('id', userId);
      return const Result.success(null);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  Future<Result<void, Failure>> uploadAvatar(String userId, List<int> imageData) async {
    try {
      final path = 'avatars/\.jpg';
      await SupabaseService.storage.from('user_avatars').uploadBinary(
          path, Uint8List.fromList(imageData), fileOptions: const FileOptions());
      await SupabaseService.client.from('profiles').update({'avatar_path': path}).eq('id', userId);
      return const Result.success(null);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }
}

final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) => ProfileRepositoryImpl());
