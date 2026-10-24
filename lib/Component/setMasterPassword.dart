import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:provider/provider.dart';

void showMasterPasswordDialog(BuildContext context, {required bool isDark, required String textData}) {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final lock = context.read<Lock>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.background(isDark),

        title: Text(
          'Set Master Password',
          style: TextStyle(
            color: AppColors.text(isDark),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_rounded, size: 50, color: AppColors.icon(isDark)),

              const SizedBox(height: 20),

              Text(
                textData,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText(isDark),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: AppColors.text(isDark)),
                decoration: InputDecoration(
                  labelText: 'Master Password',
                  prefixIcon: const Icon(Icons.key_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border(isDark)),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: AppColors.text(isDark)),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border(isDark)),
                  ),
                ),
              ),
            ],
          ),
        ),

        actions: [
          ElevatedButton(
            onPressed: () {
              final password = passwordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();

              if (password.isEmpty) {
                return;
              }

              if (password != confirmPassword) {
                return;
              }

              lock.writeMasterPasswordData(password);

              Navigator.pop(context);
            },
            child: const Text('Set Password'),
          ),
        ],
      );
    },
  );
}
