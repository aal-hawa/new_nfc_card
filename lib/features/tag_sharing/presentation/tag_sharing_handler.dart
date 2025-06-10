// lib/features/tag_sharing/presentation/tag_sharing_handler.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/nfc_scan/data/nfc_repository.dart' show nfcRepositoryProvider;
import 'package:nfc_card/features/nfc_scan/domain/nfc_service.dart';
import 'package:nfc_card/features/tag_management/presentation/tag_management_viewmodel.dart';

class TagSharingHandler {
  final Ref ref;
  bool isSharingInProgress = false;

  TagSharingHandler(this.ref);

  Future<void> toggleSharing(bool enabled) async {
    if (isSharingInProgress) return;
    
    final state = ref.read(tagManagementProvider);
    if (enabled && state.selectedTagId == null) {
      throw Exception('No tag selected');
    }

    isSharingInProgress = true;
    
    try {
      final nfcService = ref.read(nfcServiceProvider);
      if (enabled) {
        await nfcService.setHceEmulation(true);
        await _startSharing(state.selectedTagId!);
      } else {
        await _stopSharing();
      }
    } finally {
      isSharingInProgress = false;
    }
  }

Future<void> _startSharing(String tagId) async {
  final repo = ref.read(nfcRepositoryProvider);
  final tag = await repo.getTagById(tagId);
  if (tag == null) return;

  final protocolData = {
    'aid': tag.discoveredAid,
    'protocol': tag.protocolSequence?.join('|') ?? '',
    'payload': tag.payload,
  };

  await ref.read(nfcServiceProvider).setHceEmulation(true);
  // Additional sharing logic...
}

  Future<void> _stopSharing() async {
    await ref.read(nfcServiceProvider).setHceEmulation(false);
    // Additional cleanup...
  }
}

final tagSharingHandlerProvider = Provider<TagSharingHandler>((ref) {
  return TagSharingHandler(ref);
});