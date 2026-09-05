import 'package:flutter/material.dart';
import 'package:pocket_vault/Database/isar_setup.dart';
import 'package:pocket_vault/Screens/bottom_nav.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeIsar();

  final SharedPreferences prefs =
      await SharedPreferences.getInstance();

  if (prefs.getBool("screenshotProtection") ?? false) {
    await ScreenProtector.preventScreenshotOn();
  }

  if (prefs.getBool("lockAtBackground") ?? false) {
    await ScreenProtector.protectDataLeakageOn();
  }

  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNav()
    );
  }
}
