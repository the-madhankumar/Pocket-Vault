import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_vault/Database/password.model.dart';

late final Isar isar;

Future<void> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [PasswordSchema],
    directory: dir.path,
  );
}