import 'dart:io';

void main() async {
  print('🧹 Applying final clean-up fixes...');

  final replacements = {
    'game\\.flip': 'game.onCardTapped',
    'game\\.resetAll': 'game.init',
    'game\\.jumpToSentence': 'await game.init',
    'game\\.isSentenceUnlocked\\(index\\)': 'index <= game.currentSentenceIndex',
    'game\\.setCyclesTarget': 'await game.init',
  };

  await _patchFiles(Directory('lib'), replacements);

  print('✅ Done! Run flutter clean && flutter analyze');
}

Future<void> _patchFiles(Directory dir, Map<String, String> fixes) async {
  for (final f in dir.listSync(recursive: true).whereType<File>()) {
    if (!f.path.endsWith('.dart')) continue;
    var text = await f.readAsString();
    bool changed = false;
    for (final e in fixes.entries) {
      final regex = RegExp(e.key);
      if (regex.hasMatch(text)) {
        text = text.replaceAll(regex, e.value);
        changed = true;
      }
    }
    if (changed) {
      await f.writeAsString(text);
      print('🔧 Patched ${f.path}');
    }
  }
}
