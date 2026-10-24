import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:pocket_vault/Database/Password/password.model.dart';
import 'package:pocket_vault/Database/Password/password_repository.dart';
import 'package:pocket_vault/Utils/master_password_service.dart';
import 'package:pocket_vault/Utils/password_hash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptography/cryptography.dart';

class Lock extends ChangeNotifier {
  late SharedPreferences prefs;

  final masterPasswordObject = MasterPassword();
  final passwordHashObject = PasswordEncryptor();

  SecretKey? oldsecretKey;
  SecretKey? secretKey;

  Timer? timer;

  bool isLocked = true;
  bool isDarked = true;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    isDarked = prefs.getBool("Theme") ?? true;
  }

  Future<bool> checkDataAvailability() async {
    return await masterPasswordObject.checkDataAvailability();
  }

  Future<void> writeMasterPasswordData(String masterPassword) async {
    final random = Random.secure();

    final salt = List<int>.generate(16, (_) => random.nextInt(256));

    final newSecretKey = await passwordHashObject.deriveKey(
      masterPassword,
      salt,
    );

    final previousKey = secretKey;

    if (previousKey != null) {
      oldsecretKey = previousKey;
      await writeAllPasswords(previousKey, newSecretKey);
    }

    final verifier = await newSecretKey.extractBytes();

    await masterPasswordObject.writeMasterPasswordData(
      salt: salt,
      verifier: verifier,
    );

    secretKey = newSecretKey;
    oldsecretKey = null;

    notifyListeners();
  }

  Future<bool> checkMasterPassword(String masterPassword) async {
    final data = await masterPasswordObject.readMasterPasswordData();

    final salt = List<int>.from(data['salt']);
    final verifier = List<int>.from(data['verifier']);

    final candidateKey = await passwordHashObject.deriveKey(
      masterPassword,
      salt,
    );

    final enteredSecretBytes = await candidateKey.extractBytes();

    final correct = listEquals(enteredSecretBytes, verifier);

    if (correct) {
      secretKey = candidateKey;
    }

    return correct;
  }

  SecretKey? get secretKeyDerived {
    return secretKey;
  }

  Future<void> writeAllPasswords(SecretKey oldKey, SecretKey newKey) async {
    try {
      final passwordRepository = PasswordRepository();

      final currentPass = await passwordRepository.getAllPasswords();
      final updatedPasswords = <Password>[];

      for (final data in currentPass) {
        final secretBox = SecretBox(
          base64Decode(data.passwordCipherText),
          nonce: base64Decode(data.passwordNonce),
          mac: Mac(base64Decode(data.passwordMac)),
        );

        final decryptedPassword = await passwordHashObject.decryptPassword(
          secretBox,
          oldKey,
        );

        final encryptedBox = await passwordHashObject.encryptPassword(
          decryptedPassword,
          newKey,
        );

        data.passwordCipherText = base64Encode(encryptedBox.cipherText);
        data.passwordNonce = base64Encode(encryptedBox.nonce);
        data.passwordMac = base64Encode(encryptedBox.mac.bytes);

        updatedPasswords.add(data);
      }

      await passwordRepository.updateAllPasswords(updatedPasswords);
      debugPrint('All passwords re-encrypted successfully.');
    } catch (e, stackTrace) {
      debugPrint('Failed to re-encrypt passwords: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  String get autoLockTime {
    return prefs.getString("autoLock") ?? "N";
  }

  Future<void> toggleDark() async {
    isDarked = !isDarked;
    await prefs.setBool("Theme", isDarked);
    notifyListeners();
  }

  Future<void> setAutoLockTime(String time) async {
    await prefs.setString("autoLock", time);
    notifyListeners();
  }

  void startTimer() {
    timer?.cancel();

    final time = autoLockTime;

    if (time == "N") {
      return;
    }

    final seconds = int.parse(time);

    if (seconds == 0) {
      lock();
      return;
    }

    timer = Timer(Duration(seconds: seconds), () {
      lock();
    });
  }

  void lock() {
    if (isLocked) {
      return;
    }

    isLocked = true;
    timer?.cancel();
    notifyListeners();
  }

  void unlock() {
    isLocked = false;
    notifyListeners();
    startTimer();
  }

  void stopTimer() {
    timer?.cancel();
  }
}
