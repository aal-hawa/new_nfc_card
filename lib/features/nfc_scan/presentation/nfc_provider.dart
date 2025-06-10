// lib/features/nfc_scan/presentation/nfc_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/data/nfc_repository.dart';
import 'package:nfc_manager/src/nfc_manager_android/pigeon.g.dart' show TagPigeon;

class NfcState {
  final bool isScanning;
  final TagPigeon? currentTag;
  final List<TagPigeon> savedTags;

  NfcState({
    this.isScanning = false,
    this.currentTag,
    this.savedTags = const [],
  });

  // Add copyWith method
  NfcState copyWith({
    bool? isScanning,
    TagPigeon? currentTag,
    List<TagPigeon>? savedTags,
  }) {
    return NfcState(
      isScanning: isScanning ?? this.isScanning,
      currentTag: currentTag ?? this.currentTag,
      savedTags: savedTags ?? this.savedTags,
    );
  }
}

class NfcNotifier extends StateNotifier<NfcState> {
  final NfcRepository _repository;

  NfcNotifier(this._repository) : super(NfcState());

  Future<void> scanTag() async {
    state = state.copyWith(isScanning: true);
    try {
      final tag = await _repository.scanTag();
      state = state.copyWith(currentTag: tag, isScanning: false);
    } catch (e) {
      state = state.copyWith(isScanning: false);
      rethrow;
    }
  }

  // Add other state management methods
   void stopScan() {
    state = state.copyWith(isScanning: false);
    // Add any additional cleanup if needed
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState>((ref) {
  final repository = ref.read(nfcRepositoryProvider);
  return NfcNotifier(repository);
});