import 'package:json_annotation/json_annotation.dart';

part 'social_auth_request_model.g.dart';

/// Request body for `POST /auth/social/:provider`: `{ "token": "<id token>" }`.
@JsonSerializable(createFactory: false)
class SocialAuthRequestModel {
  @JsonKey(name: 'token')
  final String idToken;

  const SocialAuthRequestModel({required this.idToken});

  Map<String, dynamic> toJson() => _$SocialAuthRequestModelToJson(this);
}
