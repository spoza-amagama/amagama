// /tools/rebuild_barrels.dart
import 'dart:io';
import 'package:path/path.dart' as p;

/// 🔄 Barrel File Rebuilder (FINAL FIX)
/// ------------------------------------
/// Scans `lib/` for any `index.dart` files and automatically updates
/// their exports to include other `.dart` files in the same folder.
///
/// ✅ Fixes:
/// - Removes duplicate folder prefixes (e.g. `state/state/...`)
/// - Uses clean relative paths per directory
/// - Skips empty folders and missing files
///
/// ▶ Run once:
///   dart run tools/rebuild_barrels.dart
///
/// ▶ Watch continuously:
///   dart run tools/rebuild_barrels.dart --watch
///
Future<void> main(List<String> args) async {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('❌ No "lib/" directory found.');
    exit(1);
  }

  final watch = args.contains('--watch');
  print('🔄 Rebuilding all barrel files...');
  await _rebuildBarrels(libDir);
  print('✅ Barrel rebuild complete.');

  if (watch) {
    print('👀 Watching for changes...');
    libDir.watch(recursive: true).listen((event) async {
      if (event.type == FileSystemEvent.modify ||
          event.type == FileSystemEvent.create ||
          event.type == FileSystemEvent.delete) {
        await _rebuildBarrels(libDir);
      }
    });
  }
}

Future<void> _rebuildBarrels(Directory libDir) async {
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('index.dart')) continue;

    final folder = entity.parent;
    final dartFiles = folder
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('index.dart'))
        .toList();

    if (dartFiles.isEmpty) continue;

    final folderPath = folder.path;
    final exports = dartFiles.map((file) {
      final relPath = p.relative(file.path, from: folderPath);
      return "export '$relPath';";
    }).join('\n');

    final content = '// AUTO-GENERATED FILE — DO NOT EDIT\n$exports\n';
    entity.writeAsStringSync(content);

    print('🧩 Updated: ${p.relative(entity.path, from: libDir.path)}');
  }
}
