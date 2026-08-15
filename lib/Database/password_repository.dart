// ignore_for_file: unused_element

import 'package:isar_community/isar.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'password.model.dart';
import 'isar_setup.dart';

class PasswordRepository {
  Future<void> addPassword(PasswordModel pass) async {
    final current_password = Password(pass.userId, pass.mail, pass.password, pass.platform, pass.link);
    await isar.writeTxn(() async {
      await isar.passwords.put(current_password);
    });

    Future<List<Password>> getAllPasswords() async {
      return await isar.passwords.where().findAll();
    }

    Future<void> updateTask(Password pass) async {
      await isar.writeTxn(() async {
        await isar.passwords.put(pass);
      });
    }

    Future<void> deletePassword(Password pass) async {
      await isar.writeTxn(() async {
        await isar.passwords.delete(pass.id);
      });
    }
  }
}