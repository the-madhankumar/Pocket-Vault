import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Component/setMasterPassword.dart';
import 'package:pocket_vault/Screens/bottom_nav.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lockscreen extends StatefulWidget {
  const Lockscreen({super.key});

  @override
  State<Lockscreen> createState() => _LockscreenState();
}

class _LockscreenState extends State<Lockscreen> {
  bool isDark = true;
  final TextEditingController masterPassword = TextEditingController();

  bool obscurePassword = true;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('Theme') ?? true;
    });
  }

  Future<void> _checkMasterPassword() async {
    final lock = context.read<Lock>();

    final exists = await lock.checkDataAvailability();

    if (!exists) {
      showMasterPasswordDialog(
        context,
        isDark: isDark,
        textData:
            'Your master password is not set.\n'
            'Create one to secure your vault.',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _checkMasterPassword();
  }

  @override
  Widget build(BuildContext context) {
    final lock = context.read<Lock>();

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: AppColors.background(isDark),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border(isDark)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.surface(isDark),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    size: 38,
                    color: AppColors.icon(isDark),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'Pocket Vault',
                  style: TextStyle(
                    color: AppColors.text(isDark),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your vault is locked',
                  style: TextStyle(
                    color: AppColors.secondaryText(isDark),
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 42),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Master Password',
                    style: TextStyle(
                      color: AppColors.text(isDark),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: masterPassword,
                  obscureText: obscurePassword,
                  style: TextStyle(color: AppColors.text(isDark), fontSize: 16),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _unlock(lock);
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your master password',
                    hintStyle: TextStyle(color: AppColors.surface(isDark)),
                    prefixIcon: Icon(
                      Icons.key_rounded,
                      color: AppColors.icon(isDark),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.icon(isDark),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.icon(isDark),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.border(isDark)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.border(isDark)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      _unlock(lock);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface(isDark),
                      foregroundColor: AppColors.text(isDark),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_open_rounded, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Unlock Vault',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 15,
                      color: AppColors.icon(isDark),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Your passwords stay private',
                      style: TextStyle(
                        color: AppColors.icon(isDark),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _unlock(Lock lock) async {
    final correct = lock.checkMasterPassword(masterPassword.text);

    if (await correct) {
      lock.unlock();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
    } else {
      masterPassword.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: AppColors.icon(isDark)),
              SizedBox(width: 10),
              Text('Incorrect master password'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    masterPassword.dispose();
    super.dispose();
  }
}
