import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/models/user_document_model.dart';

class VerificationRepositoryImpl {
  Future<Result<void, Failure>> uploadDocument({
    required String userId, required String documentType, required String filePath,
    required String mimeType, required int fileSize,
  }) async {
    try {
      final docId = const Uuid().v4();
      final bucket = AppConstants.bucketUserDocuments;
      final objectPath = 'user_id_val/doc_id_val';
      await SupabaseService.storage.from(bucket).uploadBinary(
          objectPath, Uint8List(0), fileOptions: const FileOptions());
      await SupabaseService.client.from('user_documents').insert({
        'id': docId, 'user_id': userId, 'document_type': documentType,
        'file_path': objectPath, 'mime_type': mimeType, 'file_size': fileSize,
        'verification_status': AppConstants.verificationStatusPending,
      });
      return const Result.success(null);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  Future<Result<List<UserDocumentModel>, Failure>> getUserDocuments(String userId) async {
    try {
      final data = await SupabaseService.client.from('user_documents').select().eq('user_id', userId);
      return Result.success((data as List).map((j) => UserDocumentModel.fromJson(j)).toList());
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }
}

final verificationRepositoryProvider = Provider<VerificationRepositoryImpl>((ref) => VerificationRepositoryImpl());