// ignore_for_file: use_build_context_synchronously, dead_code

import 'package:flutter/material.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

Future<void> addPassword(
  BuildContext context, {
  required TextEditingController userIdController,
  required TextEditingController emailController,
  required TextEditingController platformController,
  required TextEditingController linkController,
  required TextEditingController passwordController,
  required Future<void> Function() addPass,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Add Password", style: TextStyle(color: Colors.white)),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),

            content: SizedBox(
              width: 720,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userIdController,
                      decoration: InputDecoration(
                        labelText: 'UserID',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),

                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),

                    TextField(
                      controller: platformController,
                      decoration: InputDecoration(
                        labelText: 'Platform',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),

                    TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                        labelText: 'Link',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),

                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),

                    ElevatedButton(
                      onPressed: () async {
                        if (platformController.text.trim().isEmpty ||
                            passwordController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Platform and Password are required!',
                              ),
                            ),
                          );
                          return;
                        }

                        await addPass();

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add New Pass'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
