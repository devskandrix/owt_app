import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/photo.dart';

part 'photo_model.g.dart';

@JsonSerializable(createToJson: false)
class PhotoModel {
  final String id;
  final String imageUrl;
  final int displayOrder;
  final bool isPrimary;

  const PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.displayOrder,
    required this.isPrimary,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);

  Photo toEntity() => Photo(
    id: id,
    imageUrl: imageUrl,
    displayOrder: displayOrder,
    isPrimary: isPrimary,
  );
}
