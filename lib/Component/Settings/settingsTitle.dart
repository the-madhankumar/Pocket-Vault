import 'package:flutter/material.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

Widget settingsGroupTitle(String title, {required isDark}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(
      20,
      28,
      20,
      8,
    ),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        color: AppColors.secondaryText(isDark),
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
      ),
    ),
  );
}