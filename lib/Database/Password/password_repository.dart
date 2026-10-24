// ignore_for_file: avoid_print, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'password.model.dart';
import '../isar_setup.dart';

class PasswordRepository {
  Future<void> addPass(PasswordModel pass) async {
    try {
      final box = pass.password;

      final currentPassword = Password(
        pass.userId,
        pass.mail,
        base64Encode(box.cipherText),
        base64Encode(box.nonce),
        base64Encode(box.mac.bytes),
        pass.platform,
        pass.link,
      );

      await isar.writeTxn(() async {
        await isar.passwords.put(currentPassword);
      });

      debugPrint('PASSWORD SAVED: ${currentPassword.id}');
    } catch (e, stackTrace) {
      debugPrint('PASSWORD SAVE FAILED: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Password>> getAllPasswords() async {
    return await isar.passwords.where().findAll();
  }

  Future<void> updatePassword(Password pass) async {
    await isar.writeTxn(() async {
      await isar.passwords.put(pass);
    });
  }

  Future<void> updateAllPasswords(List<Password> passwords) async {
    await isar.writeTxn(() async {
      await isar.passwords.putAll(passwords);
    });
  }

  Future<void> deletePassword(Password pass) async {
    await isar.writeTxn(() async {
      await isar.passwords.delete(pass.id);
    });
  }

  Future<void> deleteAllPasswords() async {
    await isar.writeTxn(() async {
      await isar.passwords.clear();
    });
  }

  Future<Password?> getDataById(int id) async {
    return await isar.passwords.get(id);
  }

  Future<List<Password>> search(String value) async {
    if (value.trim().isEmpty) {
      return getAllPasswords();
    }

    return await isar.passwords
        .filter()
        .userIdContains(value, caseSensitive: false)
        .or()
        .emailContains(value, caseSensitive: false)
        .or()
        .platformContains(value, caseSensitive: false)
        .or()
        .linkContains(value, caseSensitive: false)
        .findAll();
  }
}
