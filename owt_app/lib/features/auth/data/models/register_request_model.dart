import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

/// Request body for `POST /auth/register`. No `phoneNumber` field — it's
/// taken from the verified signup token server-side, never from the body.
@JsonSerializable(createFactory: false, includeIfNull: false)
class RegisterRequestModel {
  final String? fullName;

  /// `yyyy-MM-dd`.
  final String dateOfBirth;

  final String gender;

  /// The email from the social identity that started signup (e.g. Google).
  final String? email;

  const RegisterRequestModel({
    this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.email,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
