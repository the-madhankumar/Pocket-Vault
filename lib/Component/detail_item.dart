import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:pocket_vault/Utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool edit;
  final bool isDark;
  final TextEditingController? textController;

  const DetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.edit,
    required this.isDark,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.background(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border(isDark),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.icon(isDark),
            size: 20,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: edit
                      ? TextField(
                          controller: textController,
                          style: TextStyle(
                            color: AppColors.text(isDark),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: label,
                            labelStyle: TextStyle(
                              color: AppColors.secondaryText(isDark),
                            ),
                            border: InputBorder.none,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                color: AppColors.secondaryText(isDark),
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 4),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                value.isEmpty
                                    ? 'Not provided'
                                    : value,
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.text(isDark),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),

                if (!edit) ...[
                  const SizedBox(width: 8),

                  if (label == 'URL')
                    IconButton(
                      onPressed: () async {
                        try {
                          String url = value.trim();

                          if (!url.startsWith('https://') &&
                              !url.startsWith('http://')) {
                            url = 'https://$url';
                          }

                          await launchUrl(Uri.parse(url));

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Opening in browser!',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error opening URL: $e',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: Icon(
                        Icons.open_in_browser,
                        color: AppColors.icon(isDark),
                        size: 19,
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () async {
                        try {
                          await FlutterClipboard.copy(value);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Copied Successfully!',
                                ),
                              ),
                            );
                          }
                        } on ClipboardException catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error In Copying: $e',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: Icon(
                        Icons.copy_outlined,
                        color: AppColors.icon(isDark),
                        size: 19,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}