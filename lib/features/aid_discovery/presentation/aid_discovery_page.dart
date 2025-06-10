// lib/features/aid_discovery/presentation/aid_discovery_page.dart
import 'package:flutter/material.dart';
import 'package:nfc_card/features/aid_discovery/presentation/aid_discovery_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aidDiscoveryProvider = StateNotifierProvider<AidDiscoveryViewModel, AidDiscoveryState>(
  (ref) => AidDiscoveryViewModel(ref),
);

class AidDiscoveryPage extends ConsumerWidget {
  const AidDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aidDiscoveryProvider);
    final viewModel = ref.read(aidDiscoveryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AID Discovery Mode'),
        actions: [
          IconButton(
            icon: Icon(state.isDiscovering ? Icons.stop : Icons.search),
            onPressed: viewModel.toggleDiscovery,
          ),
        ],
      ),
      body: _buildBody(state, viewModel, context),
    );
  }

  Widget _buildBody(AidDiscoveryState state, AidDiscoveryViewModel viewModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reader Identification Mode',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.isDiscovering
                        ? 'Hold device near a reader to discover AIDs'
                        : 'Press start to begin discovery mode',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'In this mode, your device will:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('• Respond neutrally to all commands (SW=9000)'),
                  const Text('• Log all incoming SELECT AID commands'),
                  const Text('• Identify patterns from different reader types'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Discovered AIDs:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: state.discoveredAids.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.credit_card, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No AIDs discovered yet'),
                        Text('Hold device near a reader'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.discoveredAids.length,
                    itemBuilder: (context, index) {
                      final aid = state.discoveredAids[index];
                      return ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(aid.name ?? 'Unknown AID'),
                        subtitle: Text(aid.aid),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}