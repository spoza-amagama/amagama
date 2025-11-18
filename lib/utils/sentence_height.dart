// 📄 lib/utils/sentence_height.dart
//
// 📏 Helpers to compute dynamic sentence card / carousel heights
// based on sentence length so layout logic lives in one place.

int estimateSentenceLines(String text) {
  final est = (text.length / 32).ceil();
  return est.clamp(1, 3);
}

double computeSentenceCardHeight(int lineCount) {
  const double baseHeight = 140;
  const double perExtraLine = 26;
  const double transformAllowance = 40;

  final extraLines = lineCount - 1;
  return baseHeight + perExtraLine * extraLines + transformAllowance;
}