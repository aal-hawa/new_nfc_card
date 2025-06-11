//lib/features/nfc_scan/presentation/scan_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/presentation/nfc_provider.dart' show nfcProvider;

class ScanState {
  final bool isScanning;
  final String? tagId;
  final String? payload;
  final String? discoveredAid;
  final bool isLoading;

  ScanState({
    this.isScanning = false,
    this.tagId,
    this.payload,
    this.discoveredAid,
    this.isLoading = false,
  });

  ScanState copyWith({
    bool? isScanning,
    String? tagId,
    String? payload,
    String? discoveredAid,
    bool? isLoading,
  }) {
    return ScanState(
      isScanning: isScanning ?? this.isScanning,
      tagId: tagId ?? this.tagId,
      payload: payload ?? this.payload,
      discoveredAid: discoveredAid ?? this.discoveredAid,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ScanViewModel extends StateNotifier<ScanState> {
  final Ref ref;
  ScanViewModel(this.ref) : super(ScanState());

  Future<void> startScan() async {
    if (state.isScanning) return;
    
    state = state.copyWith(isScanning: true, isLoading: true);
    try {
      final tag = await ref.read(nfcProvider.notifier).scanTag();
      if (tag != null) {
        state = state.copyWith(
          isScanning: false,
          isLoading: false,
          tagId: tag.id,
          payload: tag.payload,
        );
      } else {
        state = state.copyWith(isScanning: false, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isScanning: false, isLoading: false);
      rethrow;
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