// lib/core/widgets/tag_card.dart
import 'package:flutter/material.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';

class TagCard extends StatelessWidget {
  final Tag tag;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isSharingEnabled;

  const TagCard({
    super.key,
    required this.tag,
    required this.onTap,
    this.isSelected = false,
    this.isSharingEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected 
            ? const BorderSide(color: Colors.blue, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.nfc, size: 40, 
                  color: isSelected ? Colors.blue : Colors.grey),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tag.id,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSharingEnabled && isSelected 
                            ? Colors.blue 
                            : Colors.grey[600],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSharingEnabled && isSelected)
                const Icon(Icons.wifi_tethering, color: Colors.blue)
              else
                const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}