// 📄 /tools/rebuild_barrels.dart
//
// 🔄 Amagama Barrel Auto-Builder
// ------------------------------------------------------------
// Rebuilds ALL barrels AND creates missing `index.dart` barrels
// wherever a folder contains Dart files.
//
// ▶ Run:
//    dart run tools/rebuild_barrels.dart
//
// ------------------------------------------------------------

import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  final libDir = Directory('lib');

  if (!libDir.existsSync()) {
    stderr.writeln('❌ ERROR: No lib/ directory found.');
    return;
  }

  print('🔍 Scanning lib/ for barrels…');

  // Scan all folders inside lib/
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! Directory) continue;

    final dir = entity;

    // Ignore macOS junk
    if (p.basename(dir.path).startsWith('.')) continue;

    // All `.dart` files in this folder (non-recursive)
    final dartFiles = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.extension(f.path) == '.dart')
        .toList();

    if (dartFiles.isEmpty) continue;

    // Ensure barrel exists
    final barrel = File(p.join(dir.path, 'index.dart'));

    // All files except index.dart
    final contentFiles = dartFiles
        .where((f) => p.basename(f.path) != 'index.dart')
        .toList();

    if (contentFiles.isEmpty) {
      // Folder has ONLY index.dart; skip
      continue;
    }

    // Build all export lines
    final exports = contentFiles
        .map((f) => "export '${p.basename(f.path)}';")
        .join('\n');

    final header = '''
// AUTO-GENERATED BARREL — DO NOT EDIT
// Updated via tools/rebuild_barrels.dart

''';

    // Write / overwrite barrel
    barrel.writeAsStringSync('$header$exports\n');

    print('🧩 Barrel updated: ${p.relative(barrel.path, from: libDir.path)}');
  }

  print('\n✨ All barrels rebuilt (and created if missing).');
}
