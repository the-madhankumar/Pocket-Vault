import 'package:flutter/material.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

class Search extends StatelessWidget {
  const Search({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.search,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          hintText: "Search passwords",
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          isDense: true,
        ),
      ),
    );
  }
}
