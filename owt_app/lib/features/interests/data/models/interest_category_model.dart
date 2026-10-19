import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/interest_category.dart';
import 'interest_model.dart';

part 'interest_category_model.g.dart';

@JsonSerializable(createToJson: false)
class InterestCategoryModel {
  final String id;
  final String name;
  final String? icon;
  @JsonKey(defaultValue: [])
  final List<InterestModel> interests;

  const InterestCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    required this.interests,
  });

  factory InterestCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$InterestCategoryModelFromJson(json);

  InterestCategory toEntity() => InterestCategory(
    id: id,
    name: name,
    icon: icon,
    interests: interests.map((interest) => interest.toEntity()).toList(),
  );
}
