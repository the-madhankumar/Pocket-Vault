import 'package:flutter/material.dart';
import 'package:pocket_vault/Screens/settings.dart';
Widget settingsCard({
  required IconData icon,
  required String label,
  SettingsInputType inputType = SettingsInputType.none,
  VoidCallback? callBack,
  bool switchValue = false,
  ValueChanged<bool>? onSwitchChanged,
  String? displayValue,
}) {
  return InkWell(
    onTap: callBack,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 23,
            color: Colors.white,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
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
}) {
  switch (inputType) {
    case SettingsInputType.dialog:
      return const Icon(
        Icons.chevron_right,
        size: 20,
        color: Colors.white38,
      );

    case SettingsInputType.dropdown:
      return Row(
        children: [
          Text(
            displayValue,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 15,
            ),
          ),

          const SizedBox(width: 10),

          const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Colors.white38,
          ),
        ],
      );

    case SettingsInputType.boolean:
      return Switch.adaptive(
        value: switchValue,
        onChanged: onSwitchChanged,
      );

    case SettingsInputType.none:
      return const SizedBox.shrink();
  }
}