// lib/models/card_item.dart
class CardItem {
  final int id;
  final String word;
  final String? avatarPath;

  bool isMatched;
  bool isFaceUp;

  // Animation flags used by round_card.dart and game_controller.dart
  bool shouldJump;
  bool shouldShake;
  bool shouldFlashRed;

  CardItem({
    required this.id,
    required this.word,
    this.avatarPath,
    this.isMatched = false,
    this.isFaceUp = false,
    this.shouldJump = false,
    this.shouldShake = false,
    this.shouldFlashRed = false,
  });

  // Copy utility (optional)
  CardItem copyWith({
    bool? isMatched,
    bool? isFaceUp,
    bool? shouldJump,
    bool? shouldShake,
    bool? shouldFlashRed,
  }) {
    return CardItem(
      id: id,
      word: word,
      avatarPath: avatarPath,
      isMatched: isMatched ?? this.isMatched,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      shouldJump: shouldJump ?? this.shouldJump,
      shouldShake: shouldShake ?? this.shouldShake,
      shouldFlashRed: shouldFlashRed ?? this.shouldFlashRed,
    );
  }
}
