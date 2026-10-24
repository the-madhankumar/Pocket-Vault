import 'package:isar_community/isar.dart';

part 'password.model.g.dart';

@Collection()
class Password {
  Id id = Isar.autoIncrement;

  late String userId;
  late String email;
  late String passwordCipherText;
  late String passwordNonce;
  late String passwordMac;
  late String platform;
  late String link;

  Password(
    this.userId,
    this.email,
    this.passwordCipherText,
    this.passwordNonce,
    this.passwordMac,
    this.platform,
    this.link,
  );
}