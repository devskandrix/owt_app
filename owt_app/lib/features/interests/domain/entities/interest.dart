import 'package:equatable/equatable.dart';

/// A single selectable pill under an [InterestCategory], e.g. "House" under
/// "Music".
class Interest extends Equatable {
  final String id;
  final String name;
  final String icon;

  const Interest({required this.id, required this.name, required this.icon});

  @override
  List<Object?> get props => [id, name, icon];
}
