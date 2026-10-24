import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';

class PasswordEncryptor {
  final _argon2 = Argon2id(
    parallelism: 2,
    memory: 10 * 1000,
    iterations: 1,
    hashLength: 32,
  );

  final _aes = AesGcm.with256bits();

  Future<SecretKey> deriveKey(String password, List<int> salt) async {
    return await _argon2.deriveKeyFromPassword(password: password, nonce: salt);
  }

  Future<SecretBox> encryptPassword(
    String password,
    SecretKey secretKey,
  ) async {
    final nonce = _aes.newNonce();

    final secretBox = await _aes.encrypt(
      utf8.encode(password),
      secretKey: secretKey,
      nonce: nonce,
    );

    return secretBox;
  }

  Future<String> decryptPassword(
    SecretBox secretBox,
    SecretKey secretKey,
  ) async {
    final clearText = await _aes.decrypt(secretBox, secretKey: secretKey);

    return utf8.decode(clearText);
  }

  List<int> generateSalt(){
    final random = Random.secure();
    return List<int>.generate(16, (_) => random.nextInt(256));
  }
}

Future<void> main() async {
  final encryptor = PasswordEncryptor();
  const masterPassword = "my-master-password";

  // Salt for Argon2id
  final random = Random.secure();
  final salt = List<int>.generate(16, (_) => random.nextInt(256));

  // Derive encryption key
  final secretKey = await encryptor.deriveKey(masterPassword, salt);

  print("Secret Key: ${await secretKey.extractBytes()}");
  print("Secret Key Type: ${secretKey.runtimeType}");

  // Password to encrypt
  const password = "MySuperSecretPassword123";

  // Encrypt
  final secretBox = await encryptor.encryptPassword(password, secretKey);

  print("\nEncrypted:");
  print("Nonce: ${secretBox.nonce}");
  print("Ciphertext: ${secretBox.cipherText}");
  print("MAC: ${secretBox.mac.bytes}");

  // Decrypt
  final decryptedPassword = await encryptor.decryptPassword(
    secretBox,
    secretKey,
  );

  print("\nDecrypted:");
  print(decryptedPassword);
}
