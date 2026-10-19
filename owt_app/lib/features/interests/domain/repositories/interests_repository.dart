import '../entities/interest_category.dart';

abstract class InterestsRepository {
  /// The interest categories to render, each with its pill options, via
  /// `GET /interests`.
  Future<List<InterestCategory>> getInterests();

  /// Persists the user's selected interest ids (3-5 total) via
  /// `PUT /users/me/interests`.
  Future<void> updateSelectedInterests(List<String> interestIds);
}
