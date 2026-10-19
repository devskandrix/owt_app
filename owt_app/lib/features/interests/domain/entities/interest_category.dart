import 'package:equatable/equatable.dart';

import 'interest.dart';

/// A section header ("Music", "Night Life", "Vibes", ...) with the pill
/// options listed under it, as returned by `GET /interests`.
class InterestCategory extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final List<Interest> interests;

  const InterestCategory({
    required this.id,
    required this.name,
    this.icon,
    required this.interests,
  });

  @override
  List<Object?> get props => [id, name, icon, interests];
}
