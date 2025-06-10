// lib/features/nfc_scan/presentation/scan_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/presentation/scan_viewmodel.dart';
import 'package:nfc_card/features/nfc_scan/presentation/widgets/nfc_scanner.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scanProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanProvider);
    final viewModel = ref.read(scanProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Scanner'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.stopScan();
            Navigator.pop(context);
          },
        ),
        actions: [
          if (state.discoveredAid != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showAidInfo(context, state.discoveredAid!),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(child: NFCScannerWidget()),
            if (state.tagId != null) ...[
              _buildScanResult(context, state),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScanResult(BuildContext context, ScanState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tag, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'SCAN RESULT',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Tag ID', state.tagId!),
            if (state.payload != null) 
              _buildInfoRow('Payload', state.payload!),
            if (state.discoveredAid != null)
              _buildInfoRow('Discovered AID', state.discoveredAid!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: ref.read(scanProvider.notifier).reset,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text('CLEAR SCAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAidInfo(BuildContext context, String aid) {
    final knownAids = {
      'A0000000031010': 'Visa PayWave',
      'A0000000041010': 'Mastercard PayPass',
      'A00000006900': 'Transit Card',
      'A0000000043060': 'Discover Zip',
      'A0000000032010': 'American Express ExpressPay',
    };

    final aidName = knownAids[aid.replaceAll(':', '')] ?? 'Unknown AID';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AID Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AID: $aid'),
            const SizedBox(height: 8),
            Text('Type: $aidName'),
            const SizedBox(height: 16),
            const Text(
              'Application Identifiers (AIDs) are used to identify specific applications on NFC cards.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}