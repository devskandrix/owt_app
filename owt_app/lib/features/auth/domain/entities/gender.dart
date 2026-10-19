/// The gender options accepted by `POST /auth/register`.
enum Gender {
  male('MALE'),
  female('FEMALE'),
  nonBinary('NON_BINARY'),
  other('OTHER');

  const Gender(this.apiValue);

  /// The exact string this option maps to in the request body.
  final String apiValue;
}
