import 'dart:convert' show base64Encode;
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:timezone/src/env.dart' show tzDataLatestVersion;

Future<void> main() async {
  final scopes = ['', '_2010-2020', '_all'];
  for (final scope in scopes) {
    var inputFileName = '$tzDataLatestVersion$scope.tzf';
    var uri = await Isolate.resolvePackageUri(
        Uri(scheme: 'package', path: 'timezone/data/$inputFileName'));
    var tzDataPath = p.fromUri(uri);
    var bytes = File(tzDataPath).readAsBytesSync();
    var encodedString = base64Encode(bytes);
    var buffer = StringBuffer();
    buffer.write('''
// This is a generted file. Do not edit.
//
// This file contains a Base64-encoded timezone database, generated from
// ${p.basename(Platform.script.path)} on ${DateTime.now()} from $inputFileName.
''');
    buffer.write('const encodedTzData = "');
    buffer.write(encodedString);
    buffer.write('";');
    File(p.setExtension(tzDataPath, '.dart'))
        .writeAsStringSync(buffer.toString());
  }
}
