// 📄 tools/fix_home_structure.dart
//
// FixHomeStructure — housekeeping for the Home UI module.
//
// What it does:
// 1. Verifies the expected home widget folders exist.
// 2. Optionally deletes legacy Home widgets that were replaced by the new
//    sections/header/sentences/actions structure.
// 3. Prints a summary of actions.
//
// It is intentionally conservative: it does NOT rewrite imports for you.
// Use it after you've migrated to the new structure.
//
// Run from repo root with:
//   dart run tools/fix_home_structure.dart

import 'dart:io';

/// Root lib path – adjust if your project layout changes.
const String libRoot = 'lib/widgets/home';

/// Toggle this to control whether legacy files are actually deleted.
const bool deleteLegacyFiles = true;

/// Legacy/obsolete files that are safe to remove once the new architecture
/// is in place. The script only deletes them if they exist.
const List<String> legacyFiles = <String>[
  // Old composite widgets (superseded by sections)
  'home_actions_row.dart',
  'home_buttons.dart',
  'home_sentence_stats.dart',
  'home_trophies_row.dart',

  // Old header variants (replaced by header/ + sections/)
  'home_header.dart',

  // Old carousel helpers you no longer use
  'home_sentence_carousel_item.dart',
];

/// Required subfolders for the new Home layout.
const List<String> expectedSubdirs = <String>[
  'sections',
  'header',
  'actions',
  'sentences',
];

Future<void> main() async {
  print('🔧 FixHomeStructure — Home UI housekeeping');
  print('Root: $libRoot\n');

  final homeDir = Directory(libRoot);

  if (!homeDir.existsSync()) {
    print('❌ Directory "$libRoot" does not exist.');
    print('   Make sure you run this from the project root.');
    exitCode = 1;
    return;
  }

  _checkSubdirectories(homeDir);
  await _handleLegacyFiles(homeDir);

  print('\n✅ FixHomeStructure completed.');
}

void _checkSubdirectories(Directory homeDir) {
  print('• Checking expected subdirectories…');

  for (final name in expectedSubdirs) {
    final dir = Directory('${homeDir.path}/$name');
    if (dir.existsSync()) {
      print('  ✅ found: ${dir.path}');
    } else {
      print('  ⚠️  missing: ${dir.path}');
    }
  }
}

Future<void> _handleLegacyFiles(Directory homeDir) async {
  print('\n• Scanning for legacy Home widgets…');

  final List<File> toDelete = <File>[];

  for (final relative in legacyFiles) {
    final file = File('${homeDir.path}/$relative');
    if (file.existsSync()) {
      toDelete.add(file);
      print('  🧹 found legacy file: ${file.path}');
    }
  }

  if (toDelete.isEmpty) {
    print('  ✅ No legacy files found.');
    return;
  }

  if (!deleteLegacyFiles) {
    print('  ⚠️ deleteLegacyFiles=false → no files will be deleted.');
    return;
  }

  print('\n  🗑 Deleting legacy files…');
  for (final file in toDelete) {
    try {
      await file.delete();
      print('    ✔ deleted: ${file.path}');
    } catch (e) {
      print('    ❌ failed to delete ${file.path}: $e');
    }
  }
}