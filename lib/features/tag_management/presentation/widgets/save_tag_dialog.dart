// lib/features/tag_management/presentation/widgets/save_tag_dialog.dart
import 'package:flutter/material.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:nfc_card/features/tag_management/presentation/tag_management_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveTagDialog extends ConsumerStatefulWidget {
  final Tag tag;

  const SaveTagDialog({
    required this.tag,
    super.key,
  });

  @override
  ConsumerState<SaveTagDialog> createState() => _SaveTagDialogState();
}

class _SaveTagDialogState extends ConsumerState<SaveTagDialog> {
  late TextEditingController _nameController;
  late TextEditingController _actionController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag.name);
    _actionController = TextEditingController(text: widget.tag.customAction ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(tagManagementProvider.notifier);

    return AlertDialog(
      title: const Text('Save NFC Tag'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tag Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.tag.discoveredAid != null) ...[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Application ID (AID)',
                  border: const OutlineInputBorder(),
                  hintText: widget.tag.discoveredAid,
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _actionController,
              decoration: const InputDecoration(
                labelText: 'Custom Action (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (widget.tag.protocolSequence != null && widget.tag.protocolSequence!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Protocol Sequence Captured',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.tag.protocolSequence!.length} steps',
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isDefault,
                  onChanged: (value) {
                    setState(() {
                      _isDefault = value ?? false;
                    });
                  },
                ),
                const Text('Set as default tag'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTag = widget.tag.copyWith(
              name: _nameController.text,
              customAction: _actionController.text.isNotEmpty ? _actionController.text : null,
            );

            viewModel.saveTag(updatedTag).then((_) {
              if (_isDefault) {
                viewModel.setDefaultTag(updatedTag.id);
              }
              Navigator.pop(context, true);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}