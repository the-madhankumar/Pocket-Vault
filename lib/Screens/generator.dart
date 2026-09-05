import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:pocket_vault/Utils/password_generator_service.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  final TextEditingController _passwordController = TextEditingController();

  double _passwordLength = 12.0;

  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeSymbols = true;
  bool _includeNumbers = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    final password = PasswordGeneratorService(
      upperCase: _includeUppercase,
      lowerCase: _includeLowercase,
      symbols: _includeSymbols,
      numbers: _includeNumbers,
      length: _passwordLength.round(),
      anyinput: _passwordController.text,
    ).generate();

    setState(() {
      _passwordController.text = password;
    });
  }

  void _copyToClipboard() {
    if (_passwordController.text.isEmpty) return;

    Clipboard.setData(ClipboardData(text: _passwordController.text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Password copied to clipboard!',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        checkColor: Colors.black,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading(text: "Password Generator"),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Tap generate to create...',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      onPressed: _generatePassword,
                      tooltip: 'Generate password',
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, color: Colors.white70),
                      onPressed: _copyToClipboard,
                      tooltip: 'Copy password',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Password Length',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Text(
                      '${_passwordLength.round()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white24,
                ),
                child: Slider(
                  value: _passwordLength,
                  min: 8,
                  max: 32,
                  divisions: 24,
                  onChanged: (value) {
                    setState(() {
                      _passwordLength = value;
                    });
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('8', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    Text('32', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Include Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _buildOptionTile(
                    title: 'Uppercase',
                    value: _includeUppercase,
                    onChanged: (val) => setState(() => _includeUppercase = val ?? false),
                  ),
                  _buildOptionTile(
                    title: 'Lowercase',
                    value: _includeLowercase,
                    onChanged: (val) => setState(() => _includeLowercase = val ?? false),
                  ),
                  _buildOptionTile(
                    title: 'Numbers',
                    value: _includeNumbers,
                    onChanged: (val) => setState(() => _includeNumbers = val ?? false),
                  ),
                  _buildOptionTile(
                    title: 'Symbols',
                    value: _includeSymbols,
                    onChanged: (val) => setState(() => _includeSymbols = val ?? false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}