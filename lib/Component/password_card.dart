import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Database/Adaptor/passwordAdaptorModel.dart';
import 'package:pocket_vault/Screens/View.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:provider/provider.dart';

Widget passwordCard({
  required BuildContext context,
  required PasswordView item,
  required Future<void> Function(PasswordView) deletePass,
  required Future<void> Function(PasswordView) updatePass,
}) {
  final isDark = context.read<Lock>().isDarked;
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => view(
        context,
        data: item,
        deletePass: deletePass,
        updatePass: updatePass,
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.secondaryText(isDark),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              item.platform.isNotEmpty ? item.platform[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.text(isDark),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.platform,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.secondaryText(isDark),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.text(isDark),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
