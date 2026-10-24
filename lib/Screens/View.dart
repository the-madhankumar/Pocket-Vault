// ignore_for_file: use_build_context_synchronously, dead_code

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Component/detail_item.dart';
import 'package:pocket_vault/Database/Adaptor/passwordAdaptorModel.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> view(
  BuildContext context, {
  required PasswordView data,
  required Future<void> Function(PasswordView) deletePass,
  required Future<void> Function(PasswordView) updatePass,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool edit = false;
  bool open = prefs.getBool("hidePasswords")!;
  bool isDark = context.read<Lock>().isDarked;

  final platformController = TextEditingController(text: data.platform);
  final userIdController = TextEditingController(text: data.userId);
  final emailController = TextEditingController(text: data.email);
  final urlController = TextEditingController(text: data.link);
  final passwordController = TextEditingController(text: data.password);

  final seconds = prefs.getString("clipboardAutoClear") ?? "N";

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.background(isDark),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),

            title: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.text(isDark),
              child: Text(
                data.platform.isNotEmpty ? data.platform[0].toUpperCase() : '?',
                style: TextStyle(
                  color: AppColors.secondaryText(isDark),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            content: SingleChildScrollView(
              child: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DetailItem(
                      label: 'Platform',
                      value: data.platform,
                      icon: Icons.language,
                      edit: edit,
                      isDark: isDark,
                      textController: edit ? platformController : null,
                    ),

                    const SizedBox(height: 14),

                    DetailItem(
                      label: 'User ID',
                      value: data.userId,
                      icon: Icons.person_outline,
                      edit: edit,
                      isDark: isDark,
                      textController: edit ? userIdController : null,
                    ),

                    const SizedBox(height: 14),

                    DetailItem(
                      label: 'Email',
                      value: data.email,
                      icon: Icons.email_outlined,
                      edit: edit,
                      isDark: isDark,
                      textController: edit ? emailController : null,
                    ),

                    const SizedBox(height: 14),

                    DetailItem(
                      label: 'URL',
                      value: data.link,
                      icon: Icons.link,
                      edit: edit,
                      isDark: isDark,
                      textController: edit ? urlController : null,
                    ),

                    const SizedBox(height: 14),

                    if (edit)
                      DetailItem(
                        label: 'PASSWORD',
                        value: data.password,
                        icon: Icons.password,
                        edit: edit,
                        isDark: isDark,
                        textController: edit ? passwordController : null,
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background(isDark),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:AppColors.border(isDark),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: AppColors.icon(isDark),
                              size: 20,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                      color: AppColors.secondaryText(isDark),
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  open
                                      ? Text(
                                          '••••••••',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.text(isDark),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            data.password,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: AppColors.text(isDark),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),

                            IconButton(
                              tooltip: open ? 'Show password' : 'Hide password',
                              onPressed: () {
                                setState(() {
                                  open = !open;
                                });
                              },
                              icon: Icon(
                                open ? Icons.visibility_off : Icons.visibility,
                                color: AppColors.icon(isDark),
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

                                  if (seconds != "N") {
                                    final clearSeconds = int.parse(seconds);

                                    if (clearSeconds == 0) {
                                      await FlutterClipboard.clear();
                                    }
                                    Future.delayed(
                                      Duration(seconds: clearSeconds),
                                      () async {
                                        try {
                                          await FlutterClipboard.clear();
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Clipboard cleanup failed : $e',
                                              ),
                                            ),
                                          );
                                          await FlutterClipboard.copy(
                                            e.toString(),
                                          );
                                        }
                                      },
                                    );
                                  }
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
                                color: AppColors.icon(isDark),
                                size: 19,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        edit
                            ? IconButton.outlined(
                                icon: Icon(Icons.save, color: AppColors.text(isDark)),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 40.0,
                                ),
                                onPressed: () async {
                                  data.platform = platformController.text;
                                  data.userId = userIdController.text;
                                  data.email = emailController.text;
                                  data.link = urlController.text;

                                  await updatePass(data);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Updated Successfully'),
                                    ),
                                  );
                                  setState(() {
                                    edit = !edit;
                                  });
                                },
                              )
                            : IconButton.outlined(
                                icon: Icon(Icons.edit, color: AppColors.text(isDark)),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 40.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    edit = !edit;
                                  });
                                },
                              ),
                        edit
                            ? IconButton.outlined(
                                icon: Icon(Icons.close, color: AppColors.text(isDark)),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 40.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    edit = false;
                                  });
                                },
                              )
                            : IconButton.outlined(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 40.0,
                                ),
                                onPressed: () async {
                                  await deletePass(data);

                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                      ],
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
