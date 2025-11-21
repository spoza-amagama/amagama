// 📄 lib/models/card_item.dart
//
// 🧩 CardItem
// ------------------------------------------------------------
// Represents a single card used in Amagama’s matching game.
//
// RESPONSIBILITIES
// • Stores each card’s unique [id], [word], and flip/match state.
// • Provides equality by ID to maintain widget stability.
// • Mutable properties [isFaceUp] and [isMatched] control UI state.
//
// RELATED CLASSES
// • [DeckBuilder] — creates CardItems for each sentence.
// • [MatchFlipCard] — visual representation.
// • [GameController] — manages card flipping and matching.
//

class CardItem {
  final int id;
  final String word;
  bool isFaceUp;
  bool isMatched;

  CardItem({
    required this.id,
    required this.word,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  // Backward compatibility for widgets still using `card.text`
  String get text => word;

  // --- Legacy property stubs for transition ---
  bool get shouldFlashRed => false;
  bool get shouldShake => false;
  String get avatarPath => 'assets/images/${word.toLowerCase()}.png';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}