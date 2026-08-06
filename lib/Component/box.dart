import 'package:flutter/material.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

Widget box({required String text, String count = "0"}) {
  return Container(
    width: 110,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: AppColors.box,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: TextStyle(fontSize: count != "0" ? 14 : 22, color: Colors.white)),
        const SizedBox(height: 6),

        count != "0"
            ? Text(
                count,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Icon(Icons.more_horiz, size: 22,),
      ],
    ),
  );
}
