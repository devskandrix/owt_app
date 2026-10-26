import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/friend.dart';
import '../../domain/usecases/get_friends.dart';

enum FriendsStatus { loading, ready, failure }

class FriendsState extends Equatable {
  final FriendsStatus status;
  final List<Friend> friends;
  final String? errorMessage;

  const FriendsState({
    this.status = FriendsStatus.loading,
    this.friends = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, friends, errorMessage];
}

/// The Friends list: loads `GET /matches` on open and on pull-to-refresh.
class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._getFriends) : super(const FriendsState());

  final GetFriends _getFriends;

  Future<void> load() async {
    // A refresh keeps showing the current list while it loads.
    if (state.status != FriendsStatus.ready) emit(const FriendsState());
    try {
      final friends = await _getFriends(const NoParams());
      if (!isClosed) {
        emit(FriendsState(status: FriendsStatus.ready, friends: friends));
      }
    } on Failure catch (f) {
      _fail(f.message);
    } catch (_) {
      _fail(AppStrings.somethingWentWrong);
    }
  }

  void _fail(String message) {
    if (isClosed) return;
    final hasList = state.status == FriendsStatus.ready;
    emit(
      FriendsState(
        status: hasList ? FriendsStatus.ready : FriendsStatus.failure,
        friends: state.friends,
        errorMessage: message,
      ),
    );
  }
}
