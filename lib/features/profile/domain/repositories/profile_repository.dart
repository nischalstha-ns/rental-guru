import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../data/models/profile_model.dart';
abstract class ProfileRepository {
  Future<Result<ProfileModel, Failure>> getProfile(String userId);
  Future<Result<void, Failure>> updateProfile(String userId, Map<String, dynamic> updates);
  Future<Result<void, Failure>> uploadAvatar(String userId, String filePath);
}