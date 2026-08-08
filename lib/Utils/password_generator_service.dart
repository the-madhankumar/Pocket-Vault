import 'dart:math';

class PasswordGeneratorService {
  final bool upperCase;
  final bool lowerCase;
  final bool symbols;
  final bool numbers;
  final int length;

  PasswordGeneratorService({
    required this.upperCase,
    required this.lowerCase,
    required this.symbols,
    required this.numbers,
    required this.length,
  });

  String availableChars = "";

  String upperCaseChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String lowerCaseChars = "abcdefghijklmnopqrstuvwxyz";
  String symbolsChars = "!@#\$%^&*";
  String numbersChars = "0123456789";

  String generate() {
    String password = "";

    if (upperCase) {
      availableChars += upperCaseChars;
    }

    if (lowerCase) {
      availableChars += lowerCaseChars;
    }

    if (symbols) {
      availableChars += symbolsChars;
    }

    if (numbers) {
      availableChars += numbersChars;
    }

    for (int i = 0; i < length; i++) {
      password += availableChars[Random().nextInt(availableChars.length)];
    }

    return password;
  }
}
