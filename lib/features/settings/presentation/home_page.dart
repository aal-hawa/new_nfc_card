// lib/features/settings/presentation/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/app/routes.dart';

final homeProvider = Provider((ref) => HomeViewModel());

class HomeViewModel {
  String? get lastAction => null; // Will be implemented with actual logic
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastAction = ref.watch(homeProvider).lastAction;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Card Manager'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.about),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            _buildLogo(),
            const SizedBox(height: 40),
            _buildActionButton(
              context,
              icon: Icons.search,
              label: 'SCAN NFC TAG',
              route: AppRoutes.scan,
              primary: true,
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              icon: Icons.list_alt,
              label: 'SAVED TAGS',
              route: AppRoutes.savedTags,
              primary: false,
            ),
            const Spacer(flex: 2),
            if (lastAction != null) _buildLastAction(context, lastAction),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue[700]?.withAlpha(50),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue[700]!, width: 2),
      ),
      child: Icon(Icons.nfc, size: 80, color: Colors.blue[700]),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool primary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(label),
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          foregroundColor: primary ? Colors.white : Colors.blue[700],
          backgroundColor: primary ? Colors.blue[700] : Colors.grey[100],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLastAction(BuildContext context, String lastAction) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'LAST ACTION',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            lastAction,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}