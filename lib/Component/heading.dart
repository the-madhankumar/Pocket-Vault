import 'package:flutter/material.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

Widget heading({
  required String text,
  required bool isDark
}) {
  return Container(
    padding: EdgeInsets.only(left: 25.0, top: 40.0),
    child: Text(
    text,
    style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: AppColors.text(isDark),
    ),
  ),
  );
}