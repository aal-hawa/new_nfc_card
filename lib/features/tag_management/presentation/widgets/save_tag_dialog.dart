// lib/features/tag_management/presentation/widgets/save_tag_dialog.dart
import 'package:flutter/material.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:nfc_card/features/tag_management/presentation/tag_management_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveTagDialog extends ConsumerStatefulWidget {
  final String tagId;
  final String payload;
  final String? discoveredAid;
  final List<String>? protocolSequence;

  const SaveTagDialog({
    required this.tagId,
    required this.payload,
    this.discoveredAid,
    this.protocolSequence,
    super.key,
  });

  @override
  ConsumerState<SaveTagDialog> createState() => _SaveTagDialogState();
}

class _SaveTagDialogState extends ConsumerState<SaveTagDialog> {
  late TextEditingController _nameController;
  late TextEditingController _actionController;
  late TextEditingController _aidController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Tag ${widget.tagId.substring(0, 4)}');
    _actionController = TextEditingController();
    _aidController = TextEditingController(text: widget.discoveredAid ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _actionController.dispose();
    _aidController.dispose();
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
            TextField(
              controller: _aidController,
              decoration: const InputDecoration(
                labelText: 'Application ID (AID)',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _actionController,
              decoration: const InputDecoration(
                labelText: 'Custom Action (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (widget.protocolSequence != null && widget.protocolSequence!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Protocol Sequence Captured',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.protocolSequence!.length} steps',
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
            final tag = Tag(
              id: widget.tagId,
              name: _nameController.text,
              payload: widget.payload,
              customAction: _actionController.text.isNotEmpty ? _actionController.text : null,
              discoveredAid: widget.discoveredAid,
              protocolSequence: widget.protocolSequence,
            );

            viewModel.saveTag(tag).then((_) {
              if (_isDefault) {
                viewModel.setDefaultTag(widget.tagId);
              }
              Navigator.pop(context);
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