// ignore_for_file: avoid_print
import 'dart:io';

/// Upgrade script for migrating Amagama project to the new
/// single-function GameController architecture.
/// ------------------------------------------------------------
/// This script:
/// • Removes legacy helper calls (flip/resetAll/jumpToSentence/etc)
/// • Updates widget calls (AnimatedMatchGrid, etc.)
/// • Adds missing widgets/play/index.dart barrel
/// • Adds CardItem property stubs (avatarPath, shouldShake)
/// • Deletes deprecated mixin and compatibility files
///
/// Run with: dart run tool/upgrade_to_new_game_controller.dart
void main() async {
  print('🚀 Starting Amagama GameController upgrade...');

  final root = Directory.current;
  final libDir = Directory('${root.path}/lib');

  // 1️⃣ Fix old GameController method calls
  await _replaceInFiles(libDir, {
    'game.flip': 'game.onCardTapped',
    'game.resetAll': 'game.init',
    'game.jumpToSentence': 'game._currentSentenceIndex =',
    'game.isSentenceUnlocked': 'index <= game.currentSentenceIndex',
    'game.setCyclesTarget': 'game._cyclesTarget =',
    'game.currentProg': 'game.progress[game.currentSentenceIndex]',
  });

  // 2️⃣ Update AnimatedMatchGrid calls
  await _replaceInFiles(libDir, {
    r'AnimatedMatchGrid\([^\)]*\)': 'AnimatedMatchGrid(cards: game.deck, onCardTap: (card) => game.onCardTapped(card))',
  });

  // 3️⃣ Ensure sentences import exists in play_screen.dart
  final playScreen = File('${libDir.path}/screens/play_screen.dart');
  if (await playScreen.exists()) {
    final contents = await playScreen.readAsString();
    if (!contents.contains("package:amagama/data/index.dart")) {
      await playScreen.writeAsString(
        "import 'package:amagama/data/index.dart';\n$contents",
      );
      print('✅ Added missing data import to play_screen.dart');
    }
  }

  // 4️⃣ Create missing widgets/play/index.dart barrel
  final playDir = Directory('${libDir.path}/widgets/play');
  final indexFile = File('${playDir.path}/index.dart');
  if (!await indexFile.exists()) {
    await indexFile.writeAsString('''
export 'animated_match_grid.dart';
export 'match_flip_card.dart';
export 'progress_message.dart';
export 'cycle_progress_bar.dart';
export 'sentence_unlock_indicator.dart';
''');
    print('✅ Created lib/widgets/play/index.dart barrel');
  }

  // 5️⃣ Add stubs to CardItem
  final cardItemFile = File('${libDir.path}/models/card_item.dart');
  if (await cardItemFile.exists()) {
    var contents = await cardItemFile.readAsString();
    if (!contents.contains('avatarPath')) {
      contents = contents.replaceFirst(
        RegExp(r'(\}\s*)$'),
        '''
  // --- Legacy property stubs for transition ---
  bool get shouldFlashRed => false;
  bool get shouldShake => false;
  String get avatarPath => 'assets/images/\${word.toLowerCase()}.png';
\\1''',
      );
      await cardItemFile.writeAsString(contents);
      print('✅ Added stub properties to CardItem');
    }
  }

  // 6️⃣ Delete compatibility mixin if exists
  final compat = File('${libDir.path}/state/game_compatibility_mixin.dart');
  if (await compat.exists()) {
    await compat.delete();
    print('🗑️  Removed old game_compatibility_mixin.dart');
  }

  print('\n🎉 Migration complete!');
  print('👉 Next: run flutter analyze && flutter run');
}

Future<void> _replaceInFiles(Directory dir, Map<String, String> replacements) async {
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    var contents = await file.readAsString();
    bool modified = false;

    for (final entry in replacements.entries) {
      final regex = RegExp(entry.key);
      if (regex.hasMatch(contents)) {
        contents = contents.replaceAll(regex, entry.value);
        modified = true;
      }
    }

    if (modified) {
      await file.writeAsString(contents);
      print('🔧 Updated ${file.path}');
    }
  }
}
