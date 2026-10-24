import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MasterPassword {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/master_password.json');
  }

  Future<File> writeMasterPasswordData({
    required List<int> salt,
    required List<int> verifier,
  }) async {
    final file = await _localFile;

    final data = {'salt': salt, 'verifier': verifier};

    return file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>> readMasterPasswordData() async {
    final file = await _localFile;
    final content = await file.readAsString();
    return jsonDecode(content);
  }

  Future<bool> checkDataAvailability() async {
    final file = await _localFile;

    if (!await file.exists()) {
      return false;
    }

    try {
      final content = await file.readAsString();

      if (content.trim().isEmpty) {
        return false;
      }

      final data = jsonDecode(content);

      return data is Map && data['salt'] is List && data['verifier'] is List;
    } catch (_) {
      return false;
    }
  }
}
