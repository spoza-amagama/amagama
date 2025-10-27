// FULL FILE PATH: tool/rebuild_barrels.dart
import 'dart:io';

/// Recursively rebuilds all `index.dart` barrel files under lib/.
void main() async {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Error: lib/ directory not found.');
    exit(1);
  }

  print('🔄 Rebuilding barrel files under lib/...');

  int updatedCount = 0;
  await for (final entity in libDir.list(recursive: true, followLinks: false)) {
    if (entity is Directory) {
      final dartFiles = entity
          .listSync()
          .whereType<File>()
          .where((f) =>
              f.path.endsWith('.dart') &&
              !f.path.endsWith('index.dart') &&
              !f.path.contains('/widgets.dart')) // avoid ambiguous duplicates
          .toList();

      if (dartFiles.isEmpty) continue;

      final buffer = StringBuffer();
      final relPath = entity.path.replaceFirst('lib/', '');
      buffer.writeln('// AUTO-GENERATED BARREL FILE');
      buffer.writeln('// FULL FILE PATH: ${entity.path}/index.dart');
      buffer.writeln('// GENERATED: ${DateTime.now()}\n');

      final exports = dartFiles
          .map((f) => "export '${f.uri.pathSegments.last}';")
          .toList()
        ..sort();

      for (final line in exports) {
        buffer.writeln(line);
      }

      final indexFile = File('${entity.path}/index.dart');
      indexFile.writeAsStringSync(buffer.toString());
      updatedCount++;
    }
  }

  print('✅ Barrel rebuild complete. $updatedCount index.dart files updated.');
}
