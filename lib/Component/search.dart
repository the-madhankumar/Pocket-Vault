import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool get isDark => context.watch<Lock>().isDarked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.box(isDark),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Search passwords",
          hintStyle: TextStyle(color: AppColors.secondaryText(isDark)),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.secondaryText(isDark),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          isDense: true,
        ),
      ),
    );
  }
}
