// lib/features/tag_sharing/presentation/tag_sharing_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/core/widgets/tag_card.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:nfc_card/features/tag_sharing/presentation/tag_sharing_viewmodel.dart';

final tagSharingProvider = StateNotifierProvider<TagSharingViewModel, TagSharingState>(
  (ref) => TagSharingViewModel(ref),
);

class TagSharingPage extends ConsumerStatefulWidget {
  const TagSharingPage({super.key});

  @override
  ConsumerState<TagSharingPage> createState() => _TagSharingPageState();
}

class _TagSharingPageState extends ConsumerState<TagSharingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tagSharingProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tagSharingProvider);
    final viewModel = ref.read(tagSharingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Tag via NFC'),
        actions: [
          Switch(
            value: state.isSharingEnabled,
            onChanged: state.isNfcSupported
                ? viewModel.toggleSharing
                : null,
            activeColor: Colors.blue,
          ),
        ],
      ),
      body: _buildContent(state, viewModel),
    );
  }

  Widget _buildContent(TagSharingState state, TagSharingViewModel viewModel) {
    if (state.isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!state.isNfcSupported) {
      return const Center(child: Text('NFC not available on this device'));
    }

    return Column(
      children: [
        _buildHceStatus(state),
        if (state.isSharingInProgress)
          const LinearProgressIndicator(),
        _buildSharingInstructions(),
        Expanded(
          child: _buildTagList(state, viewModel),
        ),
      ],
    );
  }

  Widget _buildHceStatus(TagSharingState state) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.phone_android,
                color: state.isSharingEnabled ? Colors.green : Colors.grey,
              ),
              title: Text(
                state.isSharingEnabled 
                  ? 'Ready to share via HCE'
                  : 'Sharing disabled',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                state.isSharingEnabled
                  ? 'Hold devices back-to-back to transfer'
                  : 'Toggle switch to enable sharing',
              ),
            ),
            if (state.isSharingEnabled && state.selectedTag != null)
              _buildSelectedTagInfo(state.selectedTag!),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTagInfo(Tag tag) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text('Selected Tag:', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(tag.name, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            'ID: ${tag.id}',
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSharingInstructions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Icon(Icons.phonelink_ring, size: 40, color: Colors.blue),
          SizedBox(height: 8),
          Text(
            'Hold another NFC-enabled device close to share',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTagList(TagSharingState state, TagSharingViewModel viewModel) {
    if (state.tags.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nfc, size: 60, color: Colors.grey),
            SizedBox(height: 20),
            Text('No saved tags available'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.tags.length,
      itemBuilder: (context, index) {
        final tag = state.tags[index];
        return TagCard(
          tag: tag,
          isSelected: state.selectedTag?.id == tag.id,
          isSharingEnabled: state.isSharingEnabled,
          onTap: () => viewModel.selectTag(tag.id),
        );
      },
    );
  }
}