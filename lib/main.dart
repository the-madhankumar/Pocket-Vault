import 'package:flutter/material.dart';
import 'package:pocket_vault/Screens/bottom_nav.dart';

void main() {
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
