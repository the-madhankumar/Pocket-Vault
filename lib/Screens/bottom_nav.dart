import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Screens/generator.dart';
import 'package:pocket_vault/Screens/home.dart';
import 'package:pocket_vault/Screens/settings.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;
  bool get isDark => context.watch<Lock>().isDarked;

  final List<Widget> screens = const [Home(), Generator(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Current screen
          screens[selectedIndex],

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: AppColors.background(isDark),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.secondaryText(isDark),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,

                    currentIndex: selectedIndex,

                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },

                    selectedItemColor: AppColors.text(isDark),
                    unselectedItemColor: AppColors.secondaryText(isDark),

                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'Home',
                      ),

                      BottomNavigationBarItem(
                        icon: Icon(Icons.lock_outline),
                        activeIcon: Icon(Icons.lock),
                        label: 'Generator',
                      ),

                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings_outlined),
                        activeIcon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
