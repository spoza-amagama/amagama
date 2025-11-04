class SentenceProgress {
  final int sentenceId;
  final int cyclesCompleted;
  final bool trophyBronze;
  final bool trophySilver;
  final bool trophyGold;

  SentenceProgress({
    required this.sentenceId,
    required this.cyclesCompleted,
    required this.trophyBronze,
    required this.trophySilver,
    required this.trophyGold,
  });

  factory SentenceProgress.fromJson(Map<String, dynamic> json) {
    return SentenceProgress(
      sentenceId: json['sentenceId'] as int? ?? 0,
      cyclesCompleted: json['cyclesCompleted'] as int? ?? 0,
      trophyBronze: json['trophyBronze'] as bool? ?? false,
      trophySilver: json['trophySilver'] as bool? ?? false,
      trophyGold: json['trophyGold'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'sentenceId': sentenceId,
        'cyclesCompleted': cyclesCompleted,
        'trophyBronze': trophyBronze,
        'trophySilver': trophySilver,
        'trophyGold': trophyGold,
      };

  /// 🧩 Add this method so GameController can update progress safely
  SentenceProgress copyWith({
    int? sentenceId,
    int? cyclesCompleted,
    bool? trophyBronze,
    bool? trophySilver,
    bool? trophyGold,
  }) {
    return SentenceProgress(
      sentenceId: sentenceId ?? this.sentenceId,
      cyclesCompleted: cyclesCompleted ?? this.cyclesCompleted,
      trophyBronze: trophyBronze ?? this.trophyBronze,
      trophySilver: trophySilver ?? this.trophySilver,
      trophyGold: trophyGold ?? this.trophyGold,
    );
  }
}
