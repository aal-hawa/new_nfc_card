// lib/features/tag_management/presentation/tag_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:nfc_card/features/tag_management/presentation/widgets/save_tag_dialog.dart';

class TagDetailPage extends ConsumerStatefulWidget {
  final Tag tag;
  const TagDetailPage({super.key, required this.tag});

  @override
  ConsumerState<TagDetailPage> createState() => _TagDetailPageState();
}

class _TagDetailPageState extends ConsumerState<TagDetailPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _actionController;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tag.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _showSaveDialog(context, widget.tag),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoCard(widget.tag),
            const SizedBox(height: 20),
            _buildPayloadCard(widget.tag),
            if (widget.tag.protocolSequence != null && widget.tag.protocolSequence!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildProtocolInfo(widget.tag),
            ],
            const SizedBox(height: 20),
            _buildCustomActionCard(widget.tag),
            const SizedBox(height: 20),
            _buildEditNameCard(widget.tag),
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
            _buildDetailRow('Technology', tag.protocolSequence?.join(', ') ?? 'Unknown'),
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
                  .map((tech) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('• $tech'),
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

  Future<void> _showSaveDialog(BuildContext context, Tag tag) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => SaveTagDialog(tag: tag),
    );

    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tag saved successfully')),
      );
      Navigator.pop(context);
    }
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
}