import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/Settings/settingsCard.dart';
import 'package:pocket_vault/Component/Settings/settingsTitle.dart';
import 'package:pocket_vault/Component/Settings/showdialogtime.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SettingsInputType { dialog, dropdown, boolean, none }

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool lockAtBackground = false;
  bool hidePasswords = true;
  bool screenshotProtection = true;
  bool theme = true; // black;

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0,),
          heading(text: 'Settings'),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 20),

                // Security
                settingsGroupTitle('Security'),

                settingsCard(
                  icon: Icons.lock_reset,
                  label: 'Change Master Password',
                  inputType: SettingsInputType.dialog,
                ),

                settingsCard(
                  icon: Icons.lock_sharp,
                  label: 'Auto Lock',
                  inputType: SettingsInputType.dropdown,
                  displayValue: autoLock.toString(),
                  callBack: () async {
                    final value = await showDialogTime(context: context);

                    if (value != null) {
                      setState(() {
                        autoLock = value;
                      });
                    }

                    setStringValue("autoLock", value!);
                  },
                ),

                settingsCard(
                  icon: Icons.lock_outline,
                  label: 'Lock at Background',
                  inputType: SettingsInputType.boolean,
                  switchValue: lockAtBackground,
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
                  onSwitchChanged: (value) {
                    setState(() {
                      screenshotProtection = value;
                    });

                    setBoolValue("screenshotProtection", value);
                  },
                ),

                const _SettingsDivider(),

                // Appearance
                settingsGroupTitle('Appearance'),

                settingsCard(
                  icon: Icons.color_lens_outlined,
                  label: 'Theme',
                  inputType: SettingsInputType.boolean,
                  switchValue: theme,
                  onSwitchChanged: (value) {
                    setState(() {
                      theme = value;
                    });

                    setBoolValue("Theme", value);
                  },
                ),

                const _SettingsDivider(),

                // About
                settingsGroupTitle('About'),

                settingsCard(
                  icon: Icons.info_outline,
                  label: 'About Pocket Vault',
                  inputType: SettingsInputType.none,
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
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 30,
      indent: 30,
      endIndent: 30,
      color: Colors.white12,
      thickness: 0.5,
    );
  }
}
