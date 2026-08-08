import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordModel {
  final String platform;
  final String userId;
  final String mail;
  final String password;
  final String link;

  PasswordModel({
    required this.platform,
    required this.userId,
    required this.mail,
    required this.password,
    required this.link,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      platform: json["platform"],
      userId: json["userid"],
      mail: json["mail"],
      password: json["password"],
      link: json["link"],
    );
  }
}

Future<List<PasswordModel>> loadData() async {
  final file = rootBundle.loadString('assets/test_data.json');

  final List<dynamic> decoded = jsonDecode(await file);

  return decoded
      .map((e) => PasswordModel.fromJson(e as Map<String, dynamic>))
      .toList();
}
