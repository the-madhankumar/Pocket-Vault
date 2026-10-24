import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'package:pocket_vault/Database/Adaptor/passwordAdaptorModel.dart';
import 'package:pocket_vault/Database/Password/password.model.dart';
import 'package:pocket_vault/Database/Password/password_repository.dart';
import 'package:pocket_vault/Utils/password_hash.dart';

class PasswordAdapter {
  final PasswordEncryptor encryptor;
  final PasswordRepository _passwordRepository = PasswordRepository();
  final SecretKey secretKey;

  PasswordAdapter({required this.encryptor, required this.secretKey});

  Future<PasswordView> adapt(Password obj) async {
    final box = SecretBox(
      base64Decode(obj.passwordCipherText),
      nonce: base64Decode(obj.passwordNonce),
      mac: Mac(base64Decode(obj.passwordMac)),
    );

    return PasswordView(
      id: obj.id,
      userId: obj.userId,
      email: obj.email,
      password: await encryptor.decryptPassword(box, secretKey),
      platform: obj.platform,
      link: obj.link,
    );
  }

  Future<Password> toPassword(PasswordView data) async {
    final box = await encryptor.encryptPassword(data.password, secretKey);

    final pass = Password(
      data.userId,
      data.email,
      base64Encode(box.cipherText),
      base64Encode(box.nonce),
      base64Encode(box.mac.bytes),
      data.platform,
      data.link,
    );

    pass.id = data.id;
    return pass;
  }

  Future<List<PasswordView>> getAllPasswords() async {
    final passwords = await _passwordRepository.getAllPasswords();
    final result = <PasswordView>[];

    for (final password in passwords) {
      try {
        result.add(await adapt(password));
      } catch (e) {
        print('Failed ID: ${password.id}');
        print('Platform: ${password.platform}');
        print('Error: $e');
      }
    }

    return result;
  }

  Future<void> addPass(PasswordModel pass) async {
    await _passwordRepository.addPass(pass);
  }

  Future<void> deletePassword(Password pass) async {
    await _passwordRepository.deletePassword(pass);
  }

  Future<void> updatePassword(PasswordView pass) async {
    final password = await toPassword(pass);
    await _passwordRepository.updatePassword(password);
  }

  Future<List<PasswordView>> search(String value) async {
    final passwords = await _passwordRepository.search(value);
    return Future.wait(passwords.map(adapt));
  }

  Future<void> deleteAllPasswords() async {
    return await _passwordRepository.deleteAllPasswords();
  }
}
