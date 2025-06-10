// lib/features/tag_management/presentation/saved_tags_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/app/routes.dart';
import 'package:nfc_card/core/widgets/actionable_tag_card.dart';
import 'package:nfc_card/features/tag_management/presentation/tag_management_viewmodel.dart';

final tagManagementProvider = StateNotifierProvider<TagManagementViewModel, TagManagementState>(
  (ref) => TagManagementViewModel(ref),
);

class SavedTagsPage extends ConsumerWidget {
  const SavedTagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tagManagementProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved NFC Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
          ),
          IconButton(
            icon: const Icon(Icons.credit_card),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.aids),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.tagSharing),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.aidDiscovery),
          ),
        ],
      ),
      body: state.tags.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tags.length,
              itemBuilder: (context, index) {
                final tag = state.tags[index];
                return ActionableTagCard(
                  tag: tag,
                  onDetailsPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.tagDetail,
                    arguments: tag.id,
                  ),
                  onSharePressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.tagSharing,
                    arguments: tag.id,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.nfc, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text('No saved tags yet'),
          SizedBox(height: 10),
          Text(
            'Scan a tag to save it',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}