// lib/features/nfc_scan/presentation/scan_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final scanProvider = StateNotifierProvider<ScanViewModel, ScanState>(
  (ref) => ScanViewModel(ref),
);

class ScanViewModel extends StateNotifier<ScanState> {
  final Ref ref;

  ScanViewModel(this.ref) : super(ScanState());

  void reset() {
    state = ScanState();
  }
  Future<void> startScan() async {
      state = state.copyWith(isScanning: true);
      try {
        // Implement your scan logic here
        // Example:
        // final tag = await ref.read(nfcRepositoryProvider).scanTag();
        // state = state.copyWith(
        //   isScanning: false,
        //   tagId: tag.id,
        //   payload: tag.payload,
        // );
      } catch (e) {
        state = state.copyWith(isScanning: false);
        rethrow;
      }
    }
  void stopScan() {
    // Implement stop scan logic
    state = state.copyWith(isScanning: false);
  }

  Future<void> scanTag() async {
    state = state.copyWith(isLoading: true);
    // Implement scan logic
    // state = state.copyWith(
    //   tagId: scannedId,
    //   payload: payload,
    //   discoveredAid: aid,
    //   isLoading: false
    // );
  }
}