// lib/features/nfc_scan/presentation/scan_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/data/nfc_repository.dart' show nfcRepositoryProvider;
import 'package:nfc_card/features/nfc_scan/presentation/scan_viewmodel.dart';
import 'package:nfc_card/features/nfc_scan/presentation/widgets/nfc_scanner.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart' show Tag;
import 'package:nfc_card/features/tag_management/presentation/tag_detail_page.dart' show TagDetailPage;

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
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Scanner Widget at top
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: NFCScannerWidget(),
              ),
            ),
            
            // Scan Results Section
            if (state.tag != null) ...[
              _buildScanResult(context, state.tag!),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('SAVE TAG'),
                      onPressed: () => _saveTag(context, state.tag!),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.info_outline),
                      label: const Text('DETAILS'),
                      onPressed: () => _showTagDetails(context, state.tag!),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

  // Add these new methods to ScanPage class
  Future<void> _saveTag(BuildContext context, Tag tag) async {
    try {
      // Save logic here - you'll need to implement this in your repository
      await ref.read(nfcRepositoryProvider).saveTag(tag);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tag saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving tag: $e')),
      );
    }
  }

  void _showTagDetails(BuildContext context, Tag tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TagDetailPage(tag: tag),
      ),
    );
  }
}

 // Update _buildScanResult to be more compact
Widget _buildScanResult(BuildContext context, Tag tag) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SCAN RESULT',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const Divider(height: 16),
          _buildInfoRow('Tag ID', tag.id),
          if (tag.payload != null) _buildInfoRow('Payload', tag.payload!),
          if (tag.discoveredAid != null) _buildInfoRow('AID', tag.discoveredAid!),
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
