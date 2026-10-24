import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Database/isar_setup.dart';
import 'package:pocket_vault/Screens/lockScreen.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeIsar();

  final prefs = await SharedPreferences.getInstance();

  if (prefs.getBool("screenshotProtection") ?? false) {
    await ScreenProtector.preventScreenshotOn();
  }

  if (prefs.getBool("lockAtBackground") ?? false) {
    await ScreenProtector.protectDataLeakageOn();
  }

  final lock = Lock();

  await lock.init();

  runApp(
    ChangeNotifierProvider.value(
      value: lock,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  bool showingLockScreen = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lock = context.read<Lock>();

      lock.addListener(onLockChanged);
    });
  }

  void onLockChanged() {
    final lock = context.read<Lock>();

    if (!lock.isLocked) {
      return;
    }

    if (showingLockScreen) {
      return;
    }

    showingLockScreen = true;

    navigatorKey.currentState!
        .push(
          MaterialPageRoute(
            builder: (_) => const Lockscreen(),
          ),
        )
        .then((_) {
      showingLockScreen = false;
    });
  }

  @override
  void dispose() {
    context.read<Lock>().removeListener(onLockChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const Lockscreen(),
    );
  }
}