// /lib/models/sentence.dart
class Sentence {
  final int id;
  final String text;          // ✅ property name is `text`
  final List<String> words;

  const Sentence({
    required this.id,
    required this.text,
    required this.words,
  });
}
