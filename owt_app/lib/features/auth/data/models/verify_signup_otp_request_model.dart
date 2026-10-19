import 'package:json_annotation/json_annotation.dart';

part 'verify_signup_otp_request_model.g.dart';

/// Request body for `POST /auth/signup/phone/verify-otp`.
@JsonSerializable(createFactory: false)
class VerifySignupOtpRequestModel {
  final String phoneNumber;
  final String otp;

  const VerifySignupOtpRequestModel({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() => _$VerifySignupOtpRequestModelToJson(this);
}
