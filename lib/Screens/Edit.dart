import 'package:flutter/material.dart';
import 'package:pocket_vault/Database/Password/password.model.dart';
import 'package:pocket_vault/Utils/app_colors.dart';

Future<void> editDialog(
  BuildContext context, {
  required Password data,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                data.platform[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Text(
              data.platform,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ],
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: TextEditingController(text: data.email),
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email, color: Colors.white,),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: TextEditingController(text: data.password),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, color: Colors.white),
              ),
            ),

          ],
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              // Save logic here
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),

        ],
      );
    },
  );
}