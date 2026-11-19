
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../models/property_model.dart';
abstract class PropertyRepository {
  Future<Result<List<PropertyModel>, Failure>> getAll({int page = 1, int pageSize = 20, String? search});
  Future<Result<PropertyModel, Failure>> getById(String id);
  Future<Result<PropertyModel, Failure>> create(PropertyModel property);
  Future<Result<void, Failure>> update(String id, PropertyModel property);
  Future<Result<void, Failure>> delete(String id);
}


