// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/add.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Component/password_card.dart';
import 'package:pocket_vault/Component/search.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'package:pocket_vault/Database/Password/password.model.dart';
import 'package:pocket_vault/Database/Password/password_repository.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  TextEditingController userIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController platformController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final PasswordRepository _passwordRepository = PasswordRepository();
  late Future<List<Password>> _passwordFuture;

  @override
  void initState() {
    super.initState();
    _passwordFuture = _passwordRepository.getAllPasswords();
  }

  Future<void> _addPassword() async {
    PasswordModel newpass = PasswordModel(
      platform: platformController.text,
      userId: userIdController.text,
      mail: emailController.text,
      password: passwordController.text,
      link: linkController.text,
    );
    await _passwordRepository.addPass(newpass);
    setState(() {
      _passwordFuture = _passwordRepository.getAllPasswords();
    });
  }

  Future<void> deletePass(Password pass) async {
    await _passwordRepository.deletePassword(pass);
    setState(() {
      _passwordFuture = _passwordRepository.getAllPasswords();
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
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          heading(text: "Passwords"),
          const SizedBox(height: 20.0),
          Search(controller: searchController),

          Expanded(
            child: FutureBuilder<List<Password>>(
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
            addPassword(
              context,
              userIdController: userIdController,
              emailController: emailController,
              platformController: platformController,
              linkController: linkController,
              passwordController: passwordController,
              addPass: _addPassword,
            );

            userIdController.clear();
            platformController.clear();
            emailController.clear();
            linkController.clear();
            passwordController.clear();
          },
          label: const Text("Add", style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.add, color: Colors.white),
          backgroundColor: AppColors.search,
        ),
      ),
    );
  }
}
