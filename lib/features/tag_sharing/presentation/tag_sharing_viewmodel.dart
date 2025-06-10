// lib/features/tag_sharing/presentation/tag_sharing_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';

class TagSharingState {
  final bool isInitializing;
  final bool isNfcSupported;
  final bool isSharingEnabled;
  final bool isSharingInProgress;
  final List<Tag> tags;
  final Tag? selectedTag;

  TagSharingState({
    this.isInitializing = true,
    this.isNfcSupported = false,
    this.isSharingEnabled = false,
    this.isSharingInProgress = false,
    this.tags = const [],
    this.selectedTag,
  });

  TagSharingState copyWith({
    bool? isInitializing,
    bool? isNfcSupported,
    bool? isSharingEnabled,
    bool? isSharingInProgress,
    List<Tag>? tags,
    Tag? selectedTag,
  }) {
    return TagSharingState(
      isInitializing: isInitializing ?? this.isInitializing,
      isNfcSupported: isNfcSupported ?? this.isNfcSupported,
      isSharingEnabled: isSharingEnabled ?? this.isSharingEnabled,
      isSharingInProgress: isSharingInProgress ?? this.isSharingInProgress,
      tags: tags ?? this.tags,
      selectedTag: selectedTag ?? this.selectedTag,
    );
  }
}

class TagSharingViewModel extends StateNotifier<TagSharingState> {
  final Ref ref;

  TagSharingViewModel(this.ref) : super(TagSharingState());

  Future<void> initialize() async {
    // Load tags and check NFC support
    state = state.copyWith(
      isInitializing: false,
      isNfcSupported: true, // Replace with actual check
      tags: [], // Load from repository
    );
  }

  void toggleSharing(bool enabled) {
    state = state.copyWith(isSharingEnabled: enabled);
    if (enabled) {
      _startSharing();
    } else {
      _stopSharing();
    }
  }

  void selectTag(String tagId) {
    final tag = state.tags.firstWhere((t) => t.id == tagId);
    state = state.copyWith(selectedTag: tag);
  }

  Future<void> _startSharing() async {
    state = state.copyWith(isSharingInProgress: true);
    // Implement sharing logic
    state = state.copyWith(isSharingInProgress: false);
  }

  Future<void> _stopSharing() async {
    // Implement stop sharing logic
  }
}