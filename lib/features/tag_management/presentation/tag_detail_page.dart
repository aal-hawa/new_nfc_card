// lib/features/tag_management/presentation/tag_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:nfc_card/features/tag_management/presentation/tag_management_viewmodel.dart';

class TagDetailPage extends ConsumerStatefulWidget {
  const TagDetailPage({super.key});

  @override
  ConsumerState<TagDetailPage> createState() => _TagDetailPageState();
}

class _TagDetailPageState extends ConsumerState<TagDetailPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _actionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _actionController = TextEditingController();
    _loadTagData();
  }

  Future<void> _loadTagData() async {
    final tagId = ModalRoute.of(context)?.settings.arguments as String?;
    if (tagId == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final tag = ref.read(tagManagementProvider.notifier).getTagById(tagId);
    if (tag == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    _nameController.text = tag.name;
    _actionController.text = tag.customAction ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagId = ModalRoute.of(context)?.settings.arguments as String?;
    final tag = tagId != null 
        ? ref.read(tagManagementProvider.notifier).getTagById(tagId)
        : null;

    if (tag == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tag.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTag(context, tag.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoCard(tag),
            const SizedBox(height: 20),
            _buildPayloadCard(tag),
            if (tag.protocolSequence != null && tag.protocolSequence!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildProtocolInfo(tag),
            ],
            const SizedBox(height: 20),
            _buildCustomActionCard(tag),
            const SizedBox(height: 20),
            _buildEditNameCard(tag),
            const SizedBox(height: 30),
            _buildSaveButton(context, tag),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(Tag tag) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BASIC INFORMATION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Tag Name', tag.name),
            _buildDetailRow('Tag ID', tag.id),
            _buildDetailRow('Saved At', _formatDate(tag.savedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildPayloadCard(Tag tag) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PAYLOAD DATA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            if (tag.payload != null && tag.payload!.isNotEmpty)
              SelectableText(tag.payload!, style: const TextStyle(fontSize: 14))
            else
              const Text('No payload data available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolInfo(Tag tag) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        title: const Text('Protocol Sequence'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tag.protocolSequence!
                  .map((cmd) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('• $cmd'),
                  ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomActionCard(Tag tag) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CUSTOM ACTION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _actionController,
              decoration: const InputDecoration(
                hintText: 'What should happen when this tag is scanned?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => tag.customAction = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditNameCard(Tag tag) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EDIT TAG NAME',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tag Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => tag.name = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, Tag tag) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ref.read(tagManagementProvider.notifier).saveTag(tag);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tag saved successfully')),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('SAVE CHANGES'),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTag(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Tag?'),
            content: const Text('This tag will be permanently removed'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed && mounted) {
      ref.read(tagManagementProvider.notifier).deleteTag(id);
      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}