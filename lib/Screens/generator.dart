import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_vault/Component/context/lock.dart';
import 'package:pocket_vault/Component/heading.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:pocket_vault/Utils/password_generator_service.dart';
import 'package:provider/provider.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  bool get isDark => context.read<Lock>().isDarked;

  final TextEditingController _passwordController = TextEditingController();

  double _passwordLength = 12.0;

  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeSymbols = true;
  bool _includeNumbers = true;

  @override
  void initState() {
    super.initState();
  }

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
      SnackBar(
        backgroundColor: AppColors.box(isDark),
        content: Text(
          'Password copied to clipboard!',
          style: TextStyle(
            color: AppColors.text(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearPassword() {
    if (_passwordController.text.isEmpty) return;
    _passwordController.text = "";
  }

  void _insertToken(String token) {
    final cursor = _passwordController.selection.baseOffset;
    final text = _passwordController.text;

    _passwordController.text =
        text.substring(0, cursor) + token + text.substring(cursor);

    _passwordController.selection = TextSelection.fromPosition(
      TextPosition(offset: cursor + token.length),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.text(isDark),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.text(isDark),
        checkColor: AppColors.secondaryText(isDark),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          heading(text: "PassGen", isDark: isDark),

          const SizedBox(height: 20),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface(isDark),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border(isDark)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.icon(isDark),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          style: TextStyle(
                            color: AppColors.text(isDark),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tap generate to create...',
                            hintStyle: TextStyle(
                              color: AppColors.secondaryText(isDark),
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: AppColors.icon(isDark),
                        ),
                        onPressed: _generatePassword,
                        tooltip: 'Generate password',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy_rounded,
                          color: AppColors.icon(isDark),
                        ),
                        onPressed: _copyToClipboard,
                        tooltip: 'Copy password',
                      ),
                      IconButton(
                        icon: Icon(Icons.clear, color: AppColors.icon(isDark)),
                        onPressed: _clearPassword,
                        tooltip: 'Clear Password',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Password Length',
                      style: TextStyle(
                        color: AppColors.text(isDark),
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
                        color: AppColors.box(isDark),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.secondaryText(isDark),
                        ),
                      ),
                      child: Text(
                        '${_passwordLength.round()}',
                        style: TextStyle(
                          color: AppColors.text(isDark),
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
                    activeTrackColor: AppColors.text(isDark),
                    inactiveTrackColor: AppColors.border(isDark),
                    thumbColor: AppColors.text(isDark),
                    overlayColor: AppColors.border(isDark),
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '8',
                        style: TextStyle(
                          color: AppColors.text(isDark),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '32',
                        style: TextStyle(
                          color: AppColors.text(isDark),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Include Tokens',
                  style: TextStyle(
                    color: AppColors.text(isDark),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),

                Wrap(
                  spacing: 11,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: Text(
                        'N',
                        style: TextStyle(color: AppColors.text(isDark)),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _insertToken("[N]");
                        });
                      },
                      backgroundColor: AppColors.background(isDark),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),

                    FilterChip(
                      label: Text(
                        'U',
                        style: TextStyle(color: AppColors.text(isDark)),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _insertToken("[U]");
                        });
                      },
                      backgroundColor: AppColors.background(isDark),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),

                    FilterChip(
                      label: Text(
                        'L',
                        style: TextStyle(color: AppColors.text(isDark)),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _insertToken("[L]");
                        });
                      },
                      backgroundColor: AppColors.background(isDark),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),

                    FilterChip(
                      label: Text(
                        'S',
                        style: TextStyle(color: AppColors.text(isDark)),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _insertToken("[S]");
                        });
                      },
                      backgroundColor: AppColors.background(isDark),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),

                    FilterChip(
                      label: Text(
                        '?',
                        style: TextStyle(color: AppColors.text(isDark)),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _insertToken("?");
                        });
                      },
                      backgroundColor: AppColors.background(isDark),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'Include Settings',
                  style: TextStyle(
                    color: AppColors.text(isDark),
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
                      onChanged: (val) =>
                          setState(() => _includeUppercase = val ?? false),
                    ),
                    _buildOptionTile(
                      title: 'Lowercase',
                      value: _includeLowercase,
                      onChanged: (val) =>
                          setState(() => _includeLowercase = val ?? false),
                    ),
                    _buildOptionTile(
                      title: 'Numbers',
                      value: _includeNumbers,
                      onChanged: (val) =>
                          setState(() => _includeNumbers = val ?? false),
                    ),
                    _buildOptionTile(
                      title: 'Symbols',
                      value: _includeSymbols,
                      onChanged: (val) =>
                          setState(() => _includeSymbols = val ?? false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
