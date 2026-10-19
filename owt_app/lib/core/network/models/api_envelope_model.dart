import 'package:json_annotation/json_annotation.dart';

part 'api_envelope_model.g.dart';

/// The `{ success, data, message? }` envelope this backend wraps every
/// response in. `data`'s inner shape is endpoint-specific and stays
/// untyped here — callers parse it themselves once `success` is confirmed.
@JsonSerializable(createToJson: false)
class ApiEnvelopeModel {
  final bool success;
  final Map<String, dynamic>? data;
  final String? message;

  const ApiEnvelopeModel({required this.success, this.data, this.message});

  factory ApiEnvelopeModel.fromJson(Map<String, dynamic> json) =>
      _$ApiEnvelopeModelFromJson(json);
}
