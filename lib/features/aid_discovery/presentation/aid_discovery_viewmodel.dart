// lib/features/aid_discovery/presentation/aid_discovery_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/aid_discovery/domain/discovered_aid.dart';

class AidDiscoveryState {
  final bool isDiscovering;
  final List<DiscoveredAid> discoveredAids;

  AidDiscoveryState({
    this.isDiscovering = false,
    this.discoveredAids = const [],
  });

  AidDiscoveryState copyWith({
    bool? isDiscovering,
    List<DiscoveredAid>? discoveredAids,
  }) {
    return AidDiscoveryState(
      isDiscovering: isDiscovering ?? this.isDiscovering,
      discoveredAids: discoveredAids ?? this.discoveredAids,
    );
  }
}

class AidDiscoveryViewModel extends StateNotifier<AidDiscoveryState> {
  final Ref ref;
  AidDiscoveryViewModel(this.ref) : super(AidDiscoveryState());

  Future<void> toggleDiscovery() async {
    if (state.isDiscovering) {
      await _stopDiscovery();
    } else {
      await _startDiscovery();
    }
  }

  Future<void> _startDiscovery() async {
    state = state.copyWith(isDiscovering: true);
    // Implement discovery logic
  }

  Future<void> _stopDiscovery() async {
    state = state.copyWith(isDiscovering: false);
    // Implement stop logic
  }
}