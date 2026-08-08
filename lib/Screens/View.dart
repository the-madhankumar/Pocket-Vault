// ignore_for_file: use_build_context_synchronously, dead_code

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/detail_item.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

Future<void> view(BuildContext context, {required PasswordModel data}) {
  bool open = false;

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
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),

            title: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Text(
                data.platform.isNotEmpty ? data.platform[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DetailItem(
                    label: 'Platform',
                    value: data.platform,
                    icon: Icons.language,
                  ),

                  const SizedBox(height: 14),

                  DetailItem(
                    label: 'User ID',
                    value: data.userId,
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 14),

                  DetailItem(
                    label: 'Email',
                    value: data.mail,
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 14),

                  DetailItem(label: 'URL', value: data.link, icon: Icons.link),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: Colors.white54,
                          size: 20,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                open ? data.password : '••••••••',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          tooltip: open ? 'Hide password' : 'Show password',
                          onPressed: () {
                            setState(() {
                              open = !open;
                            });
                          },
                          icon: Icon(
                            open ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),

                        IconButton(
                          onPressed: () async {
                            try {
                              await FlutterClipboard.copy(data.password);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Copied Successfully !'),
                                ),
                              );
                              Future.delayed(
                                const Duration(seconds: 30),
                                () async {
                                  try {
                                    await FlutterClipboard.clear();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Clipboard cleanup failed : $e',
                                        ),
                                      ),
                                    );
                                    await FlutterClipboard.copy(e.toString());
                                  }
                                },
                              );
                            } on ClipboardException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error In Copying : $e'),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.copy_outlined,
                            color: Colors.white54,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
