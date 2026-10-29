/// Result of `POST /matchmaking/likes` (swipe right).
enum LikeOutcome {
  /// Like sent, no mutual match yet.
  sent,

  /// The like was mutual: a new match.
  matched,

  /// Already matched with this person (any club). The server sent no new
  /// like; it posted a note into the existing chat instead.
  alreadyMatched,
}
