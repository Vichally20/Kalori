import 'package:kalori/core/utilities/app_logger.dart';
import 'package:kalori/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:kalori/features/profile/data/models/user_profile_model.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<UserProfile?> load() async {
    try {
      final json = await localDataSource.read();
      return json == null ? null : UserProfileModel.fromJson(json);
    } on FormatException catch (e, st) {
      AppLogger.e('Profile file is unreadable; starting onboarding again', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> save(UserProfile profile) => localDataSource.write(UserProfileModel.toJson(profile));

  @override
  Future<void> clear() => localDataSource.delete();
}
