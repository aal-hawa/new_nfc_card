// lib/core/widgets/actionable_tag_card.dart
import 'package:flutter/material.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';

class ActionableTagCard extends StatelessWidget {
  final Tag tag;
  final VoidCallback onDetailsPressed;
  final VoidCallback onSharePressed;

  const ActionableTagCard({
    super.key,
    required this.tag,
    required this.onDetailsPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.nfc, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tag.id,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: onSharePressed,
              tooltip: 'Share this tag',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: onDetailsPressed,
              tooltip: 'View details',
            ),
          ],
        ),
      ),
    );
  }
}