import 'package:json_annotation/json_annotation.dart';

part 'send_signup_otp_request_model.g.dart';

/// Request body for `POST /auth/signup/phone/send-otp`.
@JsonSerializable(createFactory: false)
class SendSignupOtpRequestModel {
  final String phoneNumber;

  const SendSignupOtpRequestModel({required this.phoneNumber});

  Map<String, dynamic> toJson() => _$SendSignupOtpRequestModelToJson(this);
}
