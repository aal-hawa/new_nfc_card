//lib/features/nfc_scan/presentation/scan_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/presentation/nfc_provider.dart' show nfcProvider;
import 'package:nfc_card/features/tag_management/domain/tag.dart';

class ScanState {
  final bool isScanning;
  final Tag? tag;
  final String? error;
  final bool isLoading;

  ScanState({
    this.isScanning = false,
    this.tag,
    this.error,
    this.isLoading = false,
  });

  ScanState copyWith({
    bool? isScanning,
    Tag? tag,
    String? error,
    bool? isLoading,
  }) {
    return ScanState(
      isScanning: isScanning ?? this.isScanning,
      tag: tag ?? this.tag,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ScanViewModel extends StateNotifier<ScanState> {
  final Ref ref;
  ScanViewModel(this.ref) : super(ScanState());

  Future<void> startScan() async {
    if (state.isScanning) return;
    
    state = state.copyWith(isScanning: true, isLoading: true, error: null);
    try {
      final tagData = await ref.read(nfcProvider.notifier).scanTag();
      if (tagData != null) {
        final tag = Tag(
          id: tagData.id,
          name: 'New Tag',
          savedAt: DateTime.now(),
          payload: tagData.payload,
          protocolSequence: tagData.protocolSequence,
          customAction: tagData.customAction,
          discoveredAid: tagData.discoveredAid,
        );
        
        state = state.copyWith(
          isScanning: false,
          isLoading: false,
          tag: tag,
        );
      } else {
        state = state.copyWith(
          isScanning: false, 
          isLoading: false,
          error: 'No tag detected'
        );
      }
    } catch (e) {
      state = state.copyWith(
        isScanning: false, 
        isLoading: false,
        error: 'Error scanning tag: $e'
      );
    }
  }

  void stopScan() {
    ref.read(nfcProvider.notifier).stopScan();
    state = state.copyWith(isScanning: false);
  }

  void reset() {
    ref.read(nfcProvider.notifier).clearCurrentTag();
    state = ScanState();
  }
}

final scanProvider = StateNotifierProvider<ScanViewModel, ScanState>(
  (ref) => ScanViewModel(ref),
);