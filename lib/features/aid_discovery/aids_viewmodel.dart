// lib/features/aid_discovery/presentation/aids_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_card/features/aid_discovery/domain/discovered_aid.dart';

class AidsState {
  final List<DiscoveredAid> aids;

  AidsState({this.aids = const []});

  AidsState copyWith({List<DiscoveredAid>? aids}) {
    return AidsState(aids: aids ?? this.aids);
  }
}

class AidsViewModel extends StateNotifier<AidsState> {
  final Ref ref;
  
  AidsViewModel(this.ref) : super(AidsState()) {
    _loadAids();
  }

  Future<void> _loadAids() async {
    // Load from repository
    // state = state.copyWith(aids: loadedAids);
  }

  void updateAidName(String aid, String newName) {
    final updatedAids = state.aids.map((a) {
      if (a.aid == aid) {
        return a.copyWith(name: newName);
      }
      return a;
    }).toList();
    
    state = state.copyWith(aids: updatedAids);
    // Save to repository
  }
}