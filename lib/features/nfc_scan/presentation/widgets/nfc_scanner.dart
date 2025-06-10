// lib/features/nfc_scan/presentation/widgets/nfc_scanner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/presentation/scan_viewmodel.dart';

class NFCScannerWidget extends ConsumerStatefulWidget {
  const NFCScannerWidget({super.key});

  @override
  ConsumerState<NFCScannerWidget> createState() => _NFCScannerWidgetState();
}

class _NFCScannerWidgetState extends ConsumerState<NFCScannerWidget> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanProvider);
    final viewModel = ref.read(scanProvider.notifier);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: state.isScanning
                        ? Colors.green.withAlpha(25)
                        : Colors.blue.withAlpha(25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: state.isScanning ? Colors.green : Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.nfc,
                    size: 48,
                    color: state.isScanning ? Colors.green : Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  state.isScanning ? 'SCANNING FOR TAGS...' : 'READY TO SCAN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: state.isScanning ? Colors.green : Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    state.isScanning
                        ? 'Hold your device near an NFC tag'
                        : 'Press start to begin scanning',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isScanning ? null : viewModel.startScan,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          state.isScanning ? Colors.grey : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      state.isScanning ? 'SCANNING...' : 'START SCAN',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (state.isScanning) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: viewModel.stopScan,
                      child: const Text(
                        'CANCEL SCAN',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}