import 'package:equatable/equatable.dart';

/// One interest on a profile, e.g. "Hip Hop" with icon "🎤".
class ProfileInterest extends Equatable {
  /// The interest's id (as used by `PUT /users/me/interests`); null when
  /// the API sent only a name.
  final String? id;
  final String name;

  /// Emoji from the API; null when it has none.
  final String? icon;

  const ProfileInterest({this.id, required this.name, this.icon});

  @override
  List<Object?> get props => [id, name, icon];
}
