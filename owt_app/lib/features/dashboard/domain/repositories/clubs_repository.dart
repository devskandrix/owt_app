import '../entities/club.dart';
import '../entities/home_clubs.dart';

abstract class ClubsRepository {
  /// The dashboard's four club lists via `GET /clubs/home`. [latitude] and
  /// [longitude] are optional; when omitted, `nearYou` is ordered without a
  /// device location.
  Future<HomeClubs> getHome({double? latitude, double? longitude});

  /// The trending clubs list via `GET /clubs/trending`, capped at [limit]
  /// when given.
  Future<List<Club>> getTrending({int? limit});
}
