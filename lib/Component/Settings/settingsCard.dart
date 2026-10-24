import 'package:flutter/material.dart';
import 'package:pocket_vault/Screens/settings.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

Widget settingsCard({
  required IconData icon,
  required String label,
  required bool isDark,
  SettingsInputType inputType = SettingsInputType.none,
  VoidCallback? callBack,
  bool switchValue = false,
  ValueChanged<bool>? onSwitchChanged,
  String? displayValue,
}) {
  return InkWell(
    onTap: callBack,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Icon(icon, size: 23, color: AppColors.text(isDark)),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.text(isDark),
                fontSize: 17,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
              ),
            ),
          ),

          _buildTrailingWidget(
            inputType: inputType,
            switchValue: switchValue,
            onSwitchChanged: onSwitchChanged,
            displayValue: displayValue ?? "",
            isDark: isDark,
          ),
        ],
      ),
    ),
  );
}

Widget _buildTrailingWidget({
  required SettingsInputType inputType,
  required bool switchValue,
  required ValueChanged<bool>? onSwitchChanged,
  required String displayValue,
  required bool isDark,
}) {
  switch (inputType) {
    case SettingsInputType.dialog:
      return Icon(
        Icons.chevron_right,
        size: 20,
        color: AppColors.secondaryText(isDark),
      );

    case SettingsInputType.dropdown:
      return Row(
        children: [
          Text(
            displayValue,
            style: TextStyle(
              color: AppColors.secondaryText(isDark),
              fontSize: 15,
            ),
          ),

          const SizedBox(width: 10),

          Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: AppColors.secondaryText(isDark),
          ),
        ],
      );

    case SettingsInputType.boolean:
      return Switch.adaptive(value: switchValue, onChanged: onSwitchChanged);

    case SettingsInputType.none:
      return const SizedBox.shrink();
  }
}
