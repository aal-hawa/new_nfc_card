// lib/features/aid_discovery/presentation/aids_page.dart
import 'package:flutter/material.dart';
import 'package:nfc_card/features/aid_discovery/aids_viewmodel.dart';
import 'package:nfc_card/features/aid_discovery/domain/discovered_aid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final aidsProvider = StateNotifierProvider<AidsViewModel, AidsState>(
  (ref) => AidsViewModel(ref),
);

class AidsPage extends ConsumerWidget {
  const AidsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aidsProvider);
    final viewModel = ref.read(aidsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Discovered AIDs')),
      body: state.aids.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.aids.length,
              itemBuilder: (context, index) {
                final aid = state.aids[index];
                return _buildAidCard(context, aid, viewModel);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text('No AIDs discovered yet'),
          SizedBox(height: 10),
          Text(
            'Scan NFC cards to discover AIDs',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAidCard(BuildContext context, DiscoveredAid aid, AidsViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.credit_card),
        title: Text(aid.name ?? 'Unknown AID'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AID: ${aid.aid}'),
            const SizedBox(height: 4),
            Text('Scanned: ${aid.scanCount} times'),
            Text('Last seen: ${_formatDate(aid.lastSeen)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditAidDialog(context, aid, viewModel),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  void _showEditAidDialog(BuildContext context, DiscoveredAid aid, AidsViewModel viewModel) {
    final controller = TextEditingController(text: aid.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit AID Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'AID Name',
            hintText: 'Enter a descriptive name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.updateAidName(aid.aid, controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}