// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/box.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Component/password_card.dart';
import 'package:pocket_vault/Component/search.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          heading(text: "Passwords"),
          SizedBox(height: 20.0),
          Search(controller: searchController),

          Padding(
            padding: EdgeInsetsGeometry.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: box(text: "Browser", count: "20"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: box(text: "Mobile", count: "30"),
                ),
                const SizedBox(width: 12),
                Expanded(child: box(text: "More")),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                final passwords = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: passwords.length,
                  itemBuilder: (context, index) {
                    return passwordCard(context: context, item: passwords[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
