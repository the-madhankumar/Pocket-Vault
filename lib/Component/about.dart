import 'package:flutter/material.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool isDark = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDark = prefs.getBool('Theme') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),

      appBar: AppBar(
        backgroundColor: AppColors.background(isDark),
        foregroundColor: AppColors.text(isDark),
        elevation: 0,
        title: Text(
          'About Pocket Vault',
          style: TextStyle(
            color: AppColors.text(isDark),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Icon(
            Icons.lock_rounded,
            color: AppColors.text(isDark),
            size: 48,
          ),

          const SizedBox(height: 12),

          Text(
            'Pocket Vault',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text(isDark),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'A simple place to store, manage and generate passwords.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryText(isDark),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 28),

          section(
            'What is Pocket Vault?',
            'Pocket Vault is a password manager designed to keep your '
                'passwords organized in one place. You can save account '
                'details, search your saved passwords, generate strong '
                'passwords and control how your vault protects sensitive data.',
          ),

          section(
            'Passwords',
            'The Passwords section is your main vault. Add an account '
                'with its platform name, user ID, email, password and URL. '
                'Saved passwords can be viewed, copied, searched and deleted '
                'when they are no longer required.',
          ),

          section(
            'Search',
            'Use the search bar on the Passwords screen to quickly find '
                'a saved account. Search helps you locate passwords without '
                'manually going through the entire vault.',
          ),

          section(
            'Password Generator',
            'The Generator creates passwords based on your requirements. '
                'You can choose the password length and include uppercase '
                'letters, lowercase letters, numbers and symbols.',
          ),

          section(
            'Generator Patterns',
            'The generator supports three useful ways to create passwords:\n\n'
                '1. Random password\n'
                'Leave the pattern empty and choose the required length. '
                'Example: X7@kP2!mQ9#L\n\n'
                '2. Custom characters\n'
                'Use ? to generate a random character from the selected '
                'character types. Example: MK??2026??\n\n'
                '3. Character patterns\n'
                'Use [U], [L], [N] and [S] to request a specific character type.\n\n'
                '[U] = Uppercase\n'
                '[L] = Lowercase\n'
                '[N] = Number\n'
                '[S] = Symbol\n'
                '? = Any selected character type\n\n'
                'Example pattern:\n'
                '[U][L][L][L][N][N][S]\n\n'
                'This produces a password with a specific structure such as '
                'Abcd42@. You can also combine normal characters with patterns.',
          ),

          section(
            'Copy Passwords',
            'Tap the copy button whenever you need to use a saved or '
                'generated password in another application. Clipboard '
                'auto-clear can automatically remove copied passwords after '
                'your selected time.',
          ),

          section(
            'Clipboard Auto-Clear',
            'Clipboard Auto-Clear controls how long a copied password '
                'remains available in the clipboard.\n\n'
                'Immediate → Clear immediately\n'
                '5 seconds → Clear after 5 seconds\n'
                '15 seconds → Clear after 15 seconds\n'
                '30 seconds → Clear after 30 seconds\n'
                '60 seconds → Clear after 60 seconds\n'
                'Never → Do not automatically clear the clipboard\n\n'
                'For sensitive passwords, using a short timeout is recommended.',
          ),

          section(
            'Auto Lock',
            'Auto Lock protects the vault when it has not been used for '
                'the selected period. When the timer expires, Pocket Vault '
                'locks the vault and requires the master password again.',
          ),

          section(
            'Password Visibility',
            'Passwords are hidden by default when possible. Use the '
                'visibility button when you need to temporarily view a '
                'password. Hide it again after use, especially when using '
                'your device around other people.',
          ),

          section(
            'Screenshot Protection',
            'Screenshot Protection helps prevent sensitive Pocket Vault '
                'content from being captured through screenshots or screen '
                'recording mechanisms supported by the device.',
          ),

          section(
            'Lock When Leaving the App',
            'This security option helps protect the vault when the app '
                'moves into the background. It is useful when you want the '
                'vault to require authentication whenever you leave it.',
          ),

          section(
            'Master Password',
            'Your master password is the key used to unlock your vault. '
                'Choose a strong password that you can remember and avoid '
                'reusing it for other services. Never share your master '
                'password with anyone.',
          ),

          section(
            'Security Reminder',
            'Pocket Vault provides security controls such as vault '
                'locking, password visibility control, clipboard clearing '
                'and screenshot protection. Always keep your device '
                'protected with its own screen lock and keep your Pocket '
                'Vault installation up to date.',
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Built With',
                  style: TextStyle(
                    color: AppColors.text(isDark),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Icon(
                      Icons.flutter_dash,
                      color: AppColors.secondaryText(isDark),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Flutter & Dart',
                      style: TextStyle(
                        color: AppColors.secondaryText(isDark),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.storage_rounded,
                      color: AppColors.secondaryText(isDark),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Isar — Local database',
                      style: TextStyle(
                        color: AppColors.secondaryText(isDark),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.account_tree_outlined,
                      color: AppColors.secondaryText(isDark),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Provider — State management',
                      style: TextStyle(
                        color: AppColors.secondaryText(isDark),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryText(isDark),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '© $year Pocket Vault',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryText(isDark),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.text(isDark),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            content,
            style: TextStyle(
              color: AppColors.secondaryText(isDark),
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}