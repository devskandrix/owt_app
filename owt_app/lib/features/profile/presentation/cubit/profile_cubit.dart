import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/my_profile.dart';
import '../../domain/usecases/get_my_profile.dart';

enum ProfileStatus { loading, ready, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final MyProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.loading,
    this.profile,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, profile, errorMessage];
}

/// The signed-in user's profile (`GET /users/me`), shared app-wide: the
/// Profile tab shows it, and the bottom nav shows its primary photo.
/// Loaded the first time either appears, refreshed whenever the Profile
/// tab opens or is pulled down, and cleared on sign-out.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getMyProfile) : super(const ProfileState());

  final GetMyProfile _getMyProfile;

  /// The request in flight, so overlapping callers share one.
  Future<void>? _loading;

  /// Loads only if nothing has been loaded yet (used by the bottom nav).
  Future<void> ensureLoaded() async {
    if (state.profile != null) return;
    return load();
  }

  Future<void> load() => _loading ??= _load().whenComplete(() {
    _loading = null;
  });

  /// Forgets the profile, e.g. on sign-out, so the next account starts
  /// fresh.
  void reset() {
    if (!isClosed) emit(const ProfileState());
  }

  Future<void> _load() async {
    // A refresh keeps showing the current profile while it loads.
    if (state.profile == null) emit(const ProfileState());
    try {
      final profile = await _getMyProfile(const NoParams());
      if (!isClosed) {
        emit(ProfileState(status: ProfileStatus.ready, profile: profile));
      }
    } on Failure catch (f) {
      _fail(f.message);
    } catch (_) {
      _fail(AppStrings.somethingWentWrong);
    }
  }

  void _fail(String message) {
    if (isClosed) return;
    final profile = state.profile;
    emit(
      ProfileState(
        // Keep a loaded profile on screen if only the refresh failed.
        status: profile == null ? ProfileStatus.failure : ProfileStatus.ready,
        profile: profile,
        errorMessage: message,
      ),
    );
  }
}
