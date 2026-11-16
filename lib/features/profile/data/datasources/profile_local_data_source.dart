import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Stores the user profile as a small JSON file in the app documents folder.
class ProfileLocalDataSource {
  static const String _fileName = 'kalori_profile.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_fileName');
  }

  Future<Map<String, dynamic>?> read() async {
    final file = await _file();
    if (!await file.exists()) {
      return null;
    }
    final decoded = jsonDecode(await file.readAsString());
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  Future<void> write(Map<String, dynamic> json) async {
    final file = await _file();
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(jsonEncode(json), flush: true);
    await tmp.rename(file.path);
  }

  Future<void> delete() async {
    final file = await _file();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
