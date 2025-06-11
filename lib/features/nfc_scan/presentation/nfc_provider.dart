//lib/features/nfc_scan/presentation/nfc_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/data/nfc_repository.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:nfc_manager/nfc_manager.dart' show NfcManager;

class NfcState {
  final bool isScanning;
  final Tag? currentTag;
  final List<Tag> savedTags;

  NfcState({
    this.isScanning = false,
    this.currentTag,
    this.savedTags = const [],
  });

  NfcState copyWith({
    bool? isScanning,
    Tag? currentTag,
    List<Tag>? savedTags,
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
  
  NfcNotifier(this._repository) : super(NfcState()) {
    _initNfc();
  }

  Future<void> _initNfc() async {
    final isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      throw Exception('NFC not available on this device');
    }
  }

  Future<Tag?> scanTag() async {
    if (state.isScanning) return null;
    
    state = state.copyWith(isScanning: true);
    try {
      final tag = await _repository.scanTag();
      state = state.copyWith(
        currentTag: tag,
        isScanning: false,
        savedTags: [...state.savedTags, if (tag != null) tag],
      );
      return tag;
    } catch (e) {
      state = state.copyWith(isScanning: false);
      rethrow;
    }
  }

  void stopScan() {
    if (!state.isScanning) return;
    NfcManager.instance.stopSession();
    state = state.copyWith(isScanning: false);
  }

  void clearCurrentTag() {
    state = state.copyWith(currentTag: null);
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState>((ref) {
  final repository = ref.read(nfcRepositoryProvider);
  return NfcNotifier(repository);
});