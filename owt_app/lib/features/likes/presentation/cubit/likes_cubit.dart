import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/liked_user.dart';
import 'likes_state.dart';

/// Likes list with Confirm (-> "It’s Match" banner) and dismiss actions.
///
/// TODO: load from and send Confirm/dismiss to the API once it exists —
/// for now it starts from the Figma sample data below.
class LikesCubit extends Cubit<LikesState> {
  LikesCubit()
    : super(LikesState(likes: _sampleLikes, totalLikes: _sampleTotal));

  void confirm(String id) =>
      emit(state.copyWith(matchedIds: {...state.matchedIds, id}));

  /// Removes a like (row X) or a dismissed match banner (banner X).
  void remove(String id) => emit(
    state.copyWith(
      likes: state.likes.where((like) => like.id != id).toList(),
      matchedIds: {...state.matchedIds}..remove(id),
    ),
  );

  static const int _sampleTotal = 26;
  static const List<LikedUser> _sampleLikes = [
    LikedUser(
      id: '1',
      name: 'Clarence Weissnat',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
    LikedUser(
      id: '2',
      name: 'Saul.Pagac',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
    LikedUser(
      id: '3',
      name: 'Evan Von Jr.',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
    LikedUser(
      id: '4',
      name: 'Penny Stokes',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
    LikedUser(
      id: '5',
      name: 'Ross Lindgren',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
    LikedUser(
      id: '6',
      name: 'Randall Lesch',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
    LikedUser(
      id: '7',
      name: 'Mrs. Lee Pacocha',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
    LikedUser(
      id: '8',
      name: 'Saul.Pagac',
      location: 'Mumbai, India',
      clubName: 'Hi ibiza',
    ),
  ];
}
