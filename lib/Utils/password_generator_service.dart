import 'dart:math';

class PasswordGeneratorService {
  final bool upperCase;
  final bool lowerCase;
  final bool symbols;
  final bool numbers;
  final int length;

  final String anyinput;

  PasswordGeneratorService({
    required this.upperCase,
    required this.lowerCase,
    required this.symbols,
    required this.numbers,
    required this.length,
    required this.anyinput,
  });

  String availableChars = "";

  String upperCaseChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String lowerCaseChars = "abcdefghijklmnopqrstuvwxyz";
  String symbolsChars = "!@#\$%^&*";
  String numbersChars = "0123456789";

  String getValue(expression) {
    String currentChar = "";
    switch(expression) {
        case "U":
            currentChar = upperCaseChars[Random().nextInt(upperCaseChars.length)];
            break;
        case "N":
            currentChar = numbersChars[Random().nextInt(numbersChars.length)];
            break;
        case "L":
            currentChar = lowerCaseChars[Random().nextInt(lowerCaseChars.length)];
            break;
        case "S":
            currentChar = symbolsChars[Random().nextInt(symbolsChars.length)];
            break;
    }
    return currentChar;
  }

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

    if (anyinput.isEmpty) {
      for (int i = 0; i < length; i++) {
        password += availableChars[Random().nextInt(availableChars.length)];
      }
    } else {
      int i = 0;
      int totalCharsInputs = 0;
      while (i < anyinput.length) {
        var current = anyinput[i];
        if (anyinput[i] == '?') {
          current = availableChars[Random().nextInt(availableChars.length)];
        } else if (anyinput[i] == '[') {
            if (i + 2 < anyinput.length && anyinput[i + 1] == 'U' && anyinput[i + 2] == ']') {
                current = getValue("U");
                i += 2;
            }
            else if (i + 2 < anyinput.length && anyinput[i + 1] == 'N' && anyinput[i + 2] == ']') {
                current = getValue("N");
                i += 2;
            }
            else if (i + 2 < anyinput.length && anyinput[i + 1] == 'L' && anyinput[i + 2] == ']') {
                current = getValue("L");
                i += 2;
            }
            else if (i + 2 < anyinput.length && anyinput[i + 1] == 'S' && anyinput[i + 2] == ']') {
                current = getValue("S");
                i += 2;
            }
        }

        password += current;
        totalCharsInputs += 1;
        i++;
      }

      var remaininglength = length - totalCharsInputs;
      if(remaininglength > 0){
        for (int i = 0; i < remaininglength; i++) {
            password += availableChars[Random().nextInt(availableChars.length)];
        }
      }
    }

    return password;
  }
}