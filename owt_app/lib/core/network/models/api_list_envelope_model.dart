import 'package:json_annotation/json_annotation.dart';

part 'api_list_envelope_model.g.dart';

/// The same `{ success, data, message? }` envelope as [ApiEnvelopeModel],
/// but for endpoints whose `data` is a JSON array rather than an object
/// (e.g. `GET /interests`).
@JsonSerializable(createToJson: false)
class ApiListEnvelopeModel {
  final bool success;
  final List<dynamic>? data;
  final String? message;

  /// Endpoint-specific extras alongside the list, e.g. pagination or
  /// `GET /matchmaking/discover`'s `verifiedInterval`.
  final Map<String, dynamic>? meta;

  const ApiListEnvelopeModel({
    required this.success,
    this.data,
    this.message,
    this.meta,
  });

  factory ApiListEnvelopeModel.fromJson(Map<String, dynamic> json) =>
      _$ApiListEnvelopeModelFromJson(json);
}
