import 'package:kalori/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  /// Null until onboarding has been completed.
  Future<UserProfile?> load();

  Future<void> save(UserProfile profile);

  Future<void> clear();
}
