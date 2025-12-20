import 'dart:io';
import 'dart:convert';


/// [collect_code]
///
/// it's build up the hole project in only one file named 'full_project_code.txt'
/// not only the source code but also project architecture :)
void main() async {
  final directory = Directory('lib');
  final outputFile = File('full_project_code.txt');

  if (await outputFile.exists()) {
    await outputFile.delete();
  }

  final sink = outputFile.openWrite();

  print('Starting to collect code from lib...');

  try {
    await for (final entity in directory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        if (entity.path.endsWith('.dart') &&
            !entity.path.endsWith('.g.dart') &&
            !entity.path.endsWith('.freezed.dart')) {

          print('Processing: ${entity.path}');

          sink.writeln('\n// =======================================================');
          sink.writeln('// FILE PATH: ${entity.path}');
          sink.writeln('// =======================================================\n');

          try {
            final content = await entity.readAsString();
            sink.write(content);
          } catch (e) {
            print('Error reading file ${entity.path}: $e');
          }
        }
      }
    }
  } finally {
    await sink.close();
  }

  print('Done! All code is in ${outputFile.path}');
}