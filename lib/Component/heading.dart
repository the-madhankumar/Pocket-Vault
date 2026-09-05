import 'package:flutter/material.dart';

Widget heading({
  required String text,
}) {
  return Container(
    padding: EdgeInsets.only(left: 25.0, top: 40.0),
    child: Text(
    text,
    style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  );
}