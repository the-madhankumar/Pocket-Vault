import 'package:flutter/material.dart';
import 'package:pocket_vault/Data/test_model.dart';
import 'package:pocket_vault/Screens/Edit.dart';

Widget passwordCard({
  required BuildContext context,
  required PasswordModel item,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
    child: Row(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            item.platform[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.platform,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.mail,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      editDialog(context, data: item);
                    },
                    child: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.delete, color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
