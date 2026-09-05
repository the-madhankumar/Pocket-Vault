import 'package:isar_community/isar.dart';

part 'password.model.g.dart';

@Collection()
class Password {
  Id id = Isar.autoIncrement;

  late String userId;
  late String email;
  late String password;
  late String platform;
  late String link;

  Password(this.userId, this.email, this.password, this.platform, this.link);
}