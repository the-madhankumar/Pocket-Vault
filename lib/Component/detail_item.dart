// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const DetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),

          const SizedBox(width: 12),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 4),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          value.isEmpty ? 'Not provided' : value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                if (label == 'URL')
                  IconButton(
                    onPressed: () async {
                      try {
                        String url = value.trim();

                        if(!url.startsWith("https://") && !url.startsWith("http://")) {
                          url = "https://$url";
                        }
                        await launchUrl(Uri.parse(url));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening in browser !')),
                        );
                      } on ClipboardException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error In Copying : $e')),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.open_in_browser,
                      color: Colors.white54,
                      size: 19,
                    ),
                  )
                else
                  IconButton(
                    onPressed: () async {
                      try {
                        await FlutterClipboard.copy(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied Successfully !')),
                        );
                      } on ClipboardException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error In Copying : $e')),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.copy_outlined,
                      color: Colors.white54,
                      size: 19,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
