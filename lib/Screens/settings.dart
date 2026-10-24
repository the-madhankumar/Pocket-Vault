import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/Settings/settingsCard.dart';
import 'package:pocket_vault/Component/Settings/settingsTitle.dart';
import 'package:pocket_vault/Component/Settings/showdialogtime.dart';
import 'package:pocket_vault/Component/about.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Component/setMasterPassword.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SettingsInputType { dialog, dropdown, boolean, none }

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool get isDark => context.read<Lock>().isDarked;

  bool lockAtBackground = false;
  bool hidePasswords = true;
  bool screenshotProtection = true;
  bool theme = true;

  String autoLock = "N";
  String clipboardAutoClear = "N";

  Future<void> readData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      lockAtBackground = prefs.getBool("lockAtBackground") ?? false;
      hidePasswords = prefs.getBool("hidePasswords")!;
      screenshotProtection = prefs.getBool("screenshotProtection") ?? true;
      theme = prefs.getBool("Theme") ?? true;

      autoLock = prefs.getString("autoLock") ?? "N";
      clipboardAutoClear = prefs.getString("clipboardAutoClear") ?? "N";
    });
  }

  Future<void> setBoolValue(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (key == "Theme") {
      await context.read<Lock>().toggleDark();
      return;
    }

    await prefs.setBool(key, value);

    if (key == "screenshotProtection") {
      if (value) {
        await ScreenProtector.preventScreenshotOn();
      } else {
        await ScreenProtector.preventScreenshotOff();
      }
    }

    if (key == "lockAtBackground") {
      if (value) {
        await ScreenProtector.protectDataLeakageOn();
      } else {
        await ScreenProtector.protectDataLeakageOff();
      }
    }
  }

  Future<void> setStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    final lock = context.watch<Lock>();

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          heading(text: 'Settings', isDark: isDark),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 20),

                // Security
                settingsGroupTitle('Security', isDark: isDark),

                settingsCard(
                  icon: Icons.lock_reset,
                  label: 'Change Master Password',
                  inputType: SettingsInputType.dialog,
                  isDark: isDark,
                  callBack: () => {
                    showMasterPasswordDialog(
                      context,
                      isDark: isDark,
                      textData:
                          'Update your master password.\n'
                          'Choose a new password to keep your vault secure.',
                    ),
                  },
                ),

                settingsCard(
                  icon: Icons.lock_sharp,
                  label: 'Auto Lock',
                  inputType: SettingsInputType.dropdown,
                  displayValue: autoLock.toString(),
                  isDark: isDark,
                  callBack: () async {
                    final value = await showDialogTime(context: context);

                    if (value != null) {
                      setState(() {
                        autoLock = value;
                      });

                      await lock.setAutoLockTime(value);
                      lock.startTimer();
                    }
                  },
                ),

                settingsCard(
                  icon: Icons.lock_outline,
                  label: 'Lock at Background',
                  inputType: SettingsInputType.boolean,
                  switchValue: lockAtBackground,
                  isDark: isDark,
                  onSwitchChanged: (value) {
                    setState(() {
                      lockAtBackground = value;
                    });

                    setBoolValue("lockAtBackground", value);
                  },
                ),

                settingsCard(
                  icon: Icons.password,
                  label: 'Hide Passwords by Default',
                  inputType: SettingsInputType.boolean,
                  switchValue: hidePasswords,
                  isDark: isDark,
                  onSwitchChanged: (value) {
                    setState(() {
                      hidePasswords = value;
                    });

                    setBoolValue("hidePasswords", value);
                  },
                ),

                settingsCard(
                  icon: Icons.copy_all_outlined,
                  label: 'Clipboard Auto-Clear',
                  inputType: SettingsInputType.dropdown,
                  displayValue: clipboardAutoClear.toString(),
                  isDark: isDark,
                  callBack: () async {
                    final value = await showDialogTime(context: context);

                    if (value != null) {
                      setState(() {
                        clipboardAutoClear = value;
                      });
                    }

                    setStringValue("clipboardAutoClear", value!);
                  },
                ),

                settingsCard(
                  icon: Icons.screenshot_outlined,
                  label: 'Screenshot & Screen Recording Protection',
                  inputType: SettingsInputType.boolean,
                  switchValue: screenshotProtection,
                  isDark: isDark,
                  onSwitchChanged: (value) {
                    setState(() {
                      screenshotProtection = value;
                    });

                    setBoolValue("screenshotProtection", value);
                  },
                ),

                _SettingsDivider(isDark: isDark),

                // Appearance
                settingsGroupTitle('Appearance', isDark: isDark),

                settingsCard(
                  icon: Icons.color_lens_outlined,
                  label: 'Theme',
                  inputType: SettingsInputType.boolean,
                  switchValue: theme,
                  isDark: isDark,
                  onSwitchChanged: (value) {
                    setState(() {
                      theme = value;
                    });

                    setBoolValue("Theme", value);
                  },
                ),

                _SettingsDivider(isDark: isDark),

                // About
                settingsGroupTitle('About', isDark: isDark),

                settingsCard(
                  icon: Icons.info_outline,
                  label: 'About Pocket Vault',
                  inputType: SettingsInputType.none,
                  isDark: isDark,
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const About()),
                    );
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 30,
      indent: 30,
      endIndent: 30,
      color: AppColors.secondaryText(isDark),
      thickness: 0.5,
    );
  }
}
