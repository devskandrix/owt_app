import '../entities/club.dart';
import '../entities/club_search_page.dart';
import '../entities/home_clubs.dart';
import '../entities/search_history_item.dart';

abstract class ClubsRepository {
  /// The dashboard's four club lists via `GET /clubs/home`. [latitude] and
  /// [longitude] are optional; when omitted, `nearYou` is ordered without a
  /// device location.
  Future<HomeClubs> getHome({double? latitude, double? longitude});

  /// One page of clubs via `GET /clubs/search`. [query], [city] and
  /// [country] are case-insensitive partial matches; all params optional,
  /// so calling with none lists every active club.
  Future<ClubSearchPage> search({
    String? query,
    String? city,
    String? country,
    int? limit,
    int? page,
  });

  /// Saves a tapped search result via `POST /clubs/search/history`.
  /// [query] is the text the user had typed, if any.
  Future<void> saveSearchHistory({required String clubId, String? query});

  /// Recent searches, most recent first, via `GET /clubs/search/history`.
  Future<List<SearchHistoryItem>> getSearchHistory({int? limit});

  /// Removes one recent search via `DELETE /clubs/search/history/:id`.
  Future<void> deleteSearchHistory(String historyId);

  /// Clears all recent searches via `DELETE /clubs/search/history`.
  Future<void> clearSearchHistory();

  /// The trending clubs list via `GET /clubs/trending`, capped at [limit]
  /// when given.
  Future<List<Club>> getTrending({int? limit});
}
