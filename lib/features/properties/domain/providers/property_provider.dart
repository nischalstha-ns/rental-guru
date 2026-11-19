import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/supabase_service.dart';
import '../../data/models/property_model.dart';

class PropertyRepositoryImpl {
  Future<Result<List<PropertyModel>, Failure>> getAll({int page = 1, int pageSize = 20, String? search}) async {
    try {
      var query = SupabaseService.client.from('properties').select();
      if (search != null && search.isNotEmpty) query = query.ilike('title', '%%');
      final data = await query.limit(pageSize).range((page - 1) * pageSize, (page - 1) * pageSize + pageSize);
      return Result.success((data as List).map((j) => PropertyModel.fromJson(j)).toList());
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  Future<Result<PropertyModel, Failure>> getById(String id) async {
    try {
      final data = await SupabaseService.client.from('properties').select().eq('id', id).single();
      return Result.success(PropertyModel.fromJson(data));
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  Future<Result<PropertyModel, Failure>> create(PropertyModel property) async {
    try {
      final json = property.toJson();
      final data = await SupabaseService.client.from('properties').insert(json).select().single();
      return Result.success(PropertyModel.fromJson(data));
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  Future<Result<void, Failure>> update(String id, PropertyModel property) async {
    try {
      await SupabaseService.client.from('properties').update(property.toJson()).eq('id', id);
      return const Result.success(null);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }

  Future<Result<void, Failure>> delete(String id) async {
    try {
      await SupabaseService.client.from('properties').delete().eq('id', id);
      return const Result.success(null);
    } catch (e, st) { return Result.failure(ErrorMapper.mapError(e, st)); }
  }
}

final propertyRepositoryProvider = Provider<PropertyRepositoryImpl>((ref) => PropertyRepositoryImpl());

final myPropertiesProvider = FutureProvider<List<PropertyModel>>((ref) async => []);

final propertyListProvider = FutureProvider<List<PropertyModel>>((ref) async => []);

final propertyDetailProvider = FutureProvider.family<PropertyModel, String>((ref, id) async => throw UnimplementedError());