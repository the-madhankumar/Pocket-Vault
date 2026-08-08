import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:pocket_vault/Utils/password_generator_service.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  var rating = 8.0;

  bool upperCase = false;
  bool lowerCase = false;
  bool symbols = false;
  bool numbers = false;

  String generatedPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: 20.0),
          heading(text: "Password Generator"),
          SizedBox(height: 20.0),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and value
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Password Length',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${rating.round()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Slider(
                  value: rating,
                  min: 8,
                  max: 32,
                  divisions: 24,
                  label: '${rating.round()}',
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '8',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Text(
                      '32',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Checkbox(
                      value: upperCase,
                      onChanged: (value) {
                        setState(() {
                          upperCase = value ?? false;
                        });
                      },
                    ),

                    const Text(
                      'Uppercase',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: lowerCase,
                      onChanged: (value) {
                        setState(() {
                          lowerCase = value ?? false;
                        });
                      },
                    ),

                    const Text(
                      'LowerCase',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: symbols,
                      onChanged: (value) {
                        setState(() {
                          symbols = value ?? false;
                        });
                      },
                    ),

                    const Text(
                      'Symbols',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: numbers,
                      onChanged: (value) {
                        setState(() {
                          numbers = value ?? false;
                        });
                      },
                    ),

                    const Text(
                      'Numbers',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generated Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            color: Colors.white54,
                            size: 20,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              generatedPassword.isEmpty
                                  ? 'Generate a password'
                                  : generatedPassword,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: generatedPassword.isEmpty
                                    ? Colors.white54
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: generatedPassword.isEmpty
                                    ? 0
                                    : 1,
                              ),
                            ),
                          ),

                          if (generatedPassword.isNotEmpty)
                            IconButton(
                              onPressed: () async {
                                try {
                                  await FlutterClipboard.copy(
                                    generatedPassword,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied Successfully !'),
                                    ),
                                  );
                                } on ClipboardException catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error In Copying : $e'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.copy_outlined,
                                color: Colors.white54,
                                size: 19,
                              ),
                              tooltip: 'Copy password',
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150.0,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  generatedPassword = PasswordGeneratorService(
                    upperCase: upperCase,
                    lowerCase: lowerCase,
                    symbols: symbols,
                    numbers: numbers,
                    length: rating.round(),
                  ).generate();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Generate',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
