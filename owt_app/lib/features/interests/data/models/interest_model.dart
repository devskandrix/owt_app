import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/interest.dart';

part 'interest_model.g.dart';

@JsonSerializable(createToJson: false)
class InterestModel {
  final String id;
  final String name;
  final String icon;

  const InterestModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) =>
      _$InterestModelFromJson(json);

  Interest toEntity() => Interest(id: id, name: name, icon: icon);
}
