import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../profile/domain/entities/my_profile.dart';
import '../../domain/usecases/get_friend_profile.dart';

enum FriendProfileStatus { loading, ready, failure }

class FriendProfileState extends Equatable {
  final FriendProfileStatus status;
  final MyProfile? profile;
  final String? errorMessage;

  const FriendProfileState({
    this.status = FriendProfileStatus.loading,
    this.profile,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, profile, errorMessage];
}

/// One friend's profile. Starts from [initial] (the Friends list's copy)
/// so it shows right away, then loads `GET /matches/:matchId` on open and
/// on pull-to-refresh, whose profile (interests included) replaces it.
class FriendProfileCubit extends Cubit<FriendProfileState> {
  FriendProfileCubit(this.matchId, this._getFriendProfile, {this.initial})
    : super(
        initial == null
            ? const FriendProfileState()
            : FriendProfileState(
                status: FriendProfileStatus.ready,
                profile: initial,
              ),
      );

  final MyProfile? initial;

  final String matchId;
  final GetFriendProfile _getFriendProfile;

  Future<void> load() async {
    // A refresh keeps showing the current profile while it loads.
    if (state.profile == null) emit(const FriendProfileState());
    try {
      final profile = await _getFriendProfile(matchId);
      if (!isClosed) {
        emit(
          FriendProfileState(
            status: FriendProfileStatus.ready,
            profile: profile,
          ),
        );
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
      FriendProfileState(
        status: profile == null
            ? FriendProfileStatus.failure
            : FriendProfileStatus.ready,
        profile: profile,
        errorMessage: message,
      ),
    );
  }
}
