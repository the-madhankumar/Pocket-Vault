import 'package:flutter/material.dart';

Future<String?> showDialogTime({required BuildContext context}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        backgroundColor: Colors.black,
        title: const Text("Set Time", style: TextStyle(color: Colors.white)),
        children: [
          Wrap(
            spacing: 2.0,
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "0"),
                child: AppearCircle("I"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "5"),
                child: AppearCircle("5"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "15"),
                child: AppearCircle("15"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "30"),
                child: AppearCircle("30"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "60"),
                child: AppearCircle("60"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "N"),
                child: AppearCircle("N"),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Widget AppearCircle(String value) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
    alignment: Alignment.center,
    child: Text(
      value,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
