import 'package:json_annotation/json_annotation.dart';

part 'update_interests_request_model.g.dart';

/// Request body for `PUT /users/me/interests`.
@JsonSerializable(createFactory: false)
class UpdateInterestsRequestModel {
  final List<String> interestIds;

  const UpdateInterestsRequestModel({required this.interestIds});

  Map<String, dynamic> toJson() => _$UpdateInterestsRequestModelToJson(this);
}
