import 'package:flutter/material.dart';

Widget heading({
  required String text,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25.0),
    child: Text(
    text,
    style: const TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  );
}