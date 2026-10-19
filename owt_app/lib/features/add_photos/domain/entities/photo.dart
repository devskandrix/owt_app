import 'package:equatable/equatable.dart';

/// One of the signed-in user's profile photos.
class Photo extends Equatable {
  final String id;
  final String imageUrl;
  final int displayOrder;
  final bool isPrimary;

  const Photo({
    required this.id,
    required this.imageUrl,
    required this.displayOrder,
    required this.isPrimary,
  });

  @override
  List<Object?> get props => [id, imageUrl, displayOrder, isPrimary];
}
