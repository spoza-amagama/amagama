// /lib/models/progress.dart
class SentenceProgress {
  final int sentenceId;
  final int cyclesCompleted; // 0..X
  final bool trophyBronze;
  final bool trophySilver;
  final bool trophyGold;

  const SentenceProgress({
    required this.sentenceId,
    required this.cyclesCompleted,
    required this.trophyBronze,
    required this.trophySilver,
    required this.trophyGold,
  });

  SentenceProgress copyWith({
    int? cyclesCompleted,
    bool? trophyBronze,
    bool? trophySilver,
    bool? trophyGold,
  }) => SentenceProgress(
    sentenceId: sentenceId,
    cyclesCompleted: cyclesCompleted ?? this.cyclesCompleted,
    trophyBronze: trophyBronze ?? this.trophyBronze,
    trophySilver: trophySilver ?? this.trophySilver,
    trophyGold: trophyGold ?? this.trophyGold,
  );

  Map<String, dynamic> toJson() => {
    'sentenceId': sentenceId,
    'cyclesCompleted': cyclesCompleted,
    'tb': trophyBronze,
    'ts': trophySilver,
    'tg': trophyGold,
  };

  factory SentenceProgress.fromJson(Map<String, dynamic> j) => SentenceProgress(
    sentenceId: j['sentenceId'],
    cyclesCompleted: j['cyclesCompleted'],
    trophyBronze: j['tb'] ?? false,
    trophySilver: j['ts'] ?? false,
    trophyGold: j['tg'] ?? false,
  );
}
