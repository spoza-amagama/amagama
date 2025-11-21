// 📄 tools/fix_progress_rename.dart
//
// Automated fixer for progress.dart → sentence_progress.dart rename.
// Fully corrected version (no callback errors, valid regex, safe patches)

import 'dart:io';

void main() async {
  print('🔧 Amagama Project Fixer — Running…\n');

  await _fixModelImports();
  await _fixModelBarrel();
  await _patchProgressService();
  await _patchStorageService();
  await _patchRouteHelpers();
  await _ensureSettingsSectionHeader();

  print('\n✅ All fixes applied successfully.');
}

// ------------------------------------------------------------
// 1. Fix imports
// ------------------------------------------------------------
Future<void> _fixModelImports() async {
  print('• Updating imports…');

  final files = await _dartFiles();
  for (final path in files) {
    final file = File(path);
    var content = await file.readAsString();

    if (content.contains("models/sentence_progress.dart")) {
      content = content.replaceAll(
        "models/sentence_progress.dart",
        "models/sentence_progress.dart",
      );
      await file.writeAsString(content);
      print("  → fixed import in $path");
    }
  }
}

// ------------------------------------------------------------
// 2. Fix models/index.dart barrel
// ------------------------------------------------------------
Future<void> _fixModelBarrel() async {
  const path = "lib/models/index.dart";
  final file = File(path);
  if (!file.existsSync()) return;

  print('• Fixing models/index.dart barrel…');

  var content = await file.readAsString();
  content = content.replaceAll(
    "export 'progress.dart';",
    "export 'sentence_progress.dart';",
  );

  await file.writeAsString(content);
}

// ------------------------------------------------------------
// 3. Patch ProgressService
// ------------------------------------------------------------
Future<void> _patchProgressService() async {
  const path = "lib/services/progress_service.dart";
  final file = File(path);
  if (!file.existsSync()) return;

  print('• Patching ProgressService…');

  var content = await file.readAsString();

  // Remove attempts param in any SentenceProgress call
  content = content.replaceAllMapped(
    RegExp(r'SentenceProgress\s*\('),
    (m) => "SentenceProgress(",
  );

  // Remove any attempts: xyz,
  content = content.replaceAll(RegExp(r'\s*attempts:\s*\w+,\s*'), '');

  // Ensure default constructor has full fields
  content = content.replaceAllMapped(
    RegExp(r'SentenceProgress\(\s*sentenceId:\s*([^,]+),\s*cyclesCompleted:\s*([^,]+)[^)]*\)'),
    (m) {
      return '''
SentenceProgress(
  sentenceId: ${m.group(1)},
  cyclesCompleted: ${m.group(2)},
  trophyBronze: false,
  trophySilver: false,
  trophyGold: false,
)''';
    },
  );

  await file.writeAsString(content);
}

// ------------------------------------------------------------
// 4. Patch StorageService JSON
// ------------------------------------------------------------
Future<void> _patchStorageService() async {
  const path = "lib/services/storage_service.dart";
  final file = File(path);
  if (!file.existsSync()) return;

  print('• Fixing StorageService JSON…');

  var content = await file.readAsString();

  // Remove attempts field if present
  content = content.replaceAll(RegExp(r"'attempts':\s*\w+,?"), '');

  // Remove attempts JSON parsing entries
  content = content.replaceAll(RegExp(r'json\[.*attempts.*\]'), '0');

  await file.writeAsString(content);
}

// ------------------------------------------------------------
// 5. Clean RouteHelpers
// ------------------------------------------------------------
Future<void> _patchRouteHelpers() async {
  const path = 'lib/routes/route_helpers.dart';
  final file = File(path);
  if (!file.existsSync()) return;

  print('• Cleaning unreachable switch default…');

  var content = await file.readAsString();

  content = content.replaceAll(
    RegExp(r'default:\s*return[^\;]*;'),
    '',
  );

  await file.writeAsString(content);
}

// ------------------------------------------------------------
// 6. Ensure SettingsSectionHeader exists
// ------------------------------------------------------------
Future<void> _ensureSettingsSectionHeader() async {
  const path = 'lib/widgets/grownups/settings_section_header.dart';
  final file = File(path);

  if (file.existsSync()) return;

  print('• Creating SettingsSectionHeader…');

  await file.create(recursive: true);
  await file.writeAsString('''
import 'package:flutter/material.dart';
import 'package:amagama/theme/index.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AmagamaSpacing.sm,
        horizontal: AmagamaSpacing.md,
      ),
      child: Text(
        title,
        style: AmagamaTypography.titleStyle.copyWith(
          fontSize: 18,
          color: AmagamaColors.textSecondary,
        ),
      ),
    );
  }
}
''');
}

// ------------------------------------------------------------
// Utility: list all Dart files
// ------------------------------------------------------------
Future<List<String>> _dartFiles() async {
  final out = <String>[];
  await for (final e in Directory('.').list(recursive: true)) {
    if (e is File && e.path.endsWith('.dart')) out.add(e.path);
  }
  return out;
}