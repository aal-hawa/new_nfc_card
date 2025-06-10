// lib/features/tag_management/presentation/tag_management_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:nfc_card/features/nfc_scan/data/nfc_repository.dart';

class TagManagementState {
  final List<Tag> tags;
  final bool isLoading;
  final String? selectedTagId;

  TagManagementState({
    this.tags = const [],
    this.isLoading = false,
    this.selectedTagId,
  });

  TagManagementState copyWith({
    List<Tag>? tags,
    bool? isLoading,
    String? selectedTagId,
  }) {
    return TagManagementState(
      tags: tags ?? this.tags,
      isLoading: isLoading ?? this.isLoading,
      selectedTagId: selectedTagId ?? this.selectedTagId,
    );
  }
}

class TagManagementViewModel extends StateNotifier<TagManagementState> {
  final Ref ref;

  TagManagementViewModel(this.ref) : super(TagManagementState()) {
    _loadTags();
  }

  Future<void> _loadTags() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(nfcRepositoryProvider);
    final tags = await repo.getAllTags();
    final selectedId = repo.getSelectedTagId();
    state = state.copyWith(
      tags: tags,
      isLoading: false,
      selectedTagId: selectedId,
    );
  }

   Future<void> setDefaultTag(String tagId) async {
    // Clear previous defaults
    final updatedTags = state.tags.map((tag) {
      return tag.copyWith(isDefault: tag.id == tagId);
    }).toList();


 
    await ref.read(nfcRepositoryProvider).setSelectedTagId(tagId);
    state = state.copyWith(
      tags: updatedTags,
      selectedTagId: tagId,
    );
  }
 Tag? getTagById(String id) {
    return state.tags.firstWhereOrNull((tag) => tag.id == id);
  }
  Future<void> saveTag(Tag tag) async {
    await ref.read(nfcRepositoryProvider).saveTag(tag);
    await _loadTags();
  }

  Future<void> deleteTag(String id) async {
    await ref.read(nfcRepositoryProvider).deleteTag(id);
    await _loadTags();
  }

  Future<void> setSelectedTag(String? id) async {
    await ref.read(nfcRepositoryProvider).setSelectedTagId(id);
    state = state.copyWith(selectedTagId: id);
  }

}

final tagManagementProvider = StateNotifierProvider<TagManagementViewModel, TagManagementState>(
  (ref) => TagManagementViewModel(ref),
);

// Add this extension for convenience
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}