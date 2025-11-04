// 📄 lib/utils/avatar_registry.dart
import 'dart:math';

/// Keeps a unique avatar assignment for the current round (sentence).
/// Call [startRound] once per round with the list of card IDs,
/// then use [avatarFor] to get each card's avatar asset.
class AvatarRegistry {
  AvatarRegistry._();
  static final AvatarRegistry instance = AvatarRegistry._();

  int? _currentRoundId;
  final Map<String, String> _lookup = {}; // cardId -> asset
  static const int _maxAvatars = 30;

  /// Start a new round with a fresh unique assignment.
  /// [roundId] should be the sentence ID (or any incrementing int).
  /// [cardIds] are the IDs for all cards that will be displayed this round.
  void startRound(int roundId, List<String> cardIds) {
    if (_currentRoundId == roundId) return; // already set for this round

    _currentRoundId = roundId;
    _lookup.clear();

    // Build a shuffled list of available avatar indices (1..30)
    final indices = List<int>.generate(_maxAvatars, (i) => i + 1);
    final rand = Random(roundId); // deterministic per round
    indices.shuffle(rand);

    final take = cardIds.length.clamp(0, _maxAvatars);
    for (var i = 0; i < take; i++) {
      final idx = indices[i];
      _lookup[cardIds[i]] = 'assets/avatars/animal_$idx.png';
    }
  }

  /// Returns the avatar asset for a card. If we somehow run out, we loop.
  String avatarFor(String cardId) {
    final asset = _lookup[cardId];
    if (asset != null) return asset;

    // Fallback (should be rare): assign deterministically but may collide.
    final hash = cardId.hashCode.abs() % _maxAvatars + 1;
    return 'assets/avatars/animal_$hash.png';
  }
}
