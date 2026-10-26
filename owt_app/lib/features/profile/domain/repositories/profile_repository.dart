import '../entities/my_profile.dart';

abstract class ProfileRepository {
  /// `GET /users/me`: the signed-in user's profile.
  Future<MyProfile> getMyProfile();

  /// `DELETE /users/me`: deactivates (soft-deletes) the account.
  Future<void> deactivateAccount();
}
