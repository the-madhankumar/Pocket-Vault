// ignore_for_file: non_constant_identifier_names

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/add.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Component/password_card.dart';
import 'package:pocket_vault/Component/search.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'package:pocket_vault/Database/Adaptor/passwordAdaptor.dart';
import 'package:pocket_vault/Database/Adaptor/passwordAdaptorModel.dart';
import 'package:pocket_vault/Database/Password/password.model.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:pocket_vault/Utils/password_hash.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool get isDark => context.read<Lock>().isDarked;

  TextEditingController searchController = TextEditingController();

  TextEditingController userIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController platformController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late final PasswordAdapter _passwordRepository;

  late Future<List<PasswordView>> _passwordFuture;
  late PasswordEncryptor passEncrypt = PasswordEncryptor();
  late SecretKey skey;

  @override
  void initState() {
    super.initState();

    final lock = context.read<Lock>();

    skey = lock.secretKeyDerived!;

    _passwordRepository = PasswordAdapter(
      encryptor: PasswordEncryptor(),
      secretKey: skey,
    );

    _passwordFuture = _passwordRepository.getAllPasswords();
  }

  Future<void> _addPassword() async {
    SecretBox updatedPassword = await passEncrypt.encryptPassword(
      passwordController.text,
      skey,
    );

    PasswordModel newpass = PasswordModel(
      platform: platformController.text,
      userId: userIdController.text,
      mail: emailController.text,
      password: updatedPassword,
      link: linkController.text,
    );
    await _passwordRepository.addPass(newpass);
    setState(() {
      _passwordFuture = _passwordRepository.getAllPasswords();
    });
  }

  Future<void> deletePass(PasswordView pass) async {
    Password updatedPass = await _passwordRepository.toPassword(pass);
    await _passwordRepository.deletePassword(updatedPass);
    setState(() {
      _passwordFuture = _passwordRepository.getAllPasswords();
    });
  }

  Future<void> updatePass(PasswordView pass) async {
    await _passwordRepository.updatePassword(pass);
    setState(() {
      _passwordFuture = _passwordRepository.getAllPasswords();
    });
  }

  Future<void> _searchPasswords(String value) async {
    setState(() {
      _passwordFuture = value.trim().isEmpty
          ? _passwordRepository.getAllPasswords()
          : _passwordRepository.search(value);
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    userIdController.dispose();
    emailController.dispose();
    platformController.dispose();
    linkController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading(text: "Passwords", isDark: isDark),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Material(
                  color: AppColors.box(isDark),
                  borderRadius: BorderRadius.circular(14),
                  child: IconButton(
                    tooltip: "Delete all passwords",
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.background(isDark),
                          title: Text(
                            "Delete all passwords?",
                            style: TextStyle(color: AppColors.text(isDark)),
                          ),
                          content: Text(
                            "This will permanently delete all saved passwords.",
                            style: TextStyle(
                              color: AppColors.text(
                                isDark,
                              ).withValues(alpha: 0.7),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: AppColors.text(isDark)),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                              ),
                              child: const Text("Delete All"),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      await _passwordRepository.deleteAllPasswords();

                      if (!mounted) return;

                      setState(() {
                        _passwordFuture = _passwordRepository.getAllPasswords();
                      });
                    },
                    icon: const Icon(Icons.delete_sweep_rounded),
                    color: Colors.redAccent,
                    iconSize: 23,
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Search(controller: searchController, onChanged: _searchPasswords),

          Expanded(
            child: FutureBuilder<List<PasswordView>>(
              future: _passwordFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final passwords = (snapshot.data ?? [])
                    .where(
                      (p) =>
                          p.platform.trim().isNotEmpty &&
                          p.password.trim().isNotEmpty,
                    )
                    .toList();

                if (passwords.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: const Icon(
                                Icons.lock_outline_rounded,
                                size: 42,
                                color: Colors.white54,
                              ),
                            ),

                            const SizedBox(height: 24),

                            const Text(
                              'No Passwords Yet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Your saved passwords will appear here. '
                              'Add your first one to get started.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Ensure ListView takes the constraints cleanly
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: passwords.length,
                  itemBuilder: (context, index) {
                    return passwordCard(
                      context: context,
                      item: passwords[index],
                      deletePass: deletePass,
                      updatePass: updatePass,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await addPassword(
              context,
              userIdController: userIdController,
              emailController: emailController,
              platformController: platformController,
              linkController: linkController,
              passwordController: passwordController,
              addPass: _addPassword,
            );

            if (!context.mounted) return;

            userIdController.clear();
            platformController.clear();
            emailController.clear();
            linkController.clear();
            passwordController.clear();
          },
          label: Text("Add", style: TextStyle(color: AppColors.text(isDark))),
          icon: Icon(Icons.add, color: AppColors.icon(isDark)),
          backgroundColor: AppColors.box(isDark),
        ),
      ),
    );
  }
}
