// lib/features/nfc_scan/domain/nfc_service.dart
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class NfcService {
  final MethodChannel _platform = const MethodChannel('com.example.nfc_card/sharing');

  Future<bool> isAvailable() => NfcManager.instance.isAvailable();
  
  Future<void> startSession({
    required Function(NfcTag) onDiscovered,
    Set<NfcPollingOption> pollingOptions = const {
      NfcPollingOption.iso14443,
      NfcPollingOption.iso15693,
      NfcPollingOption.iso18092,
    },
  }) async {
    await NfcManager.instance.startSession(
      onDiscovered: onDiscovered,
      pollingOptions: pollingOptions,
    );
  }

  Future<void> stopSession() => NfcManager.instance.stopSession();

  // HCE Methods
  Future<bool> setHceEmulation(bool active) async {
    try {
      return await _platform.invokeMethod('setHceEmulation', {'active': active});
    } on PlatformException {
      return false;
    }
  }

  Future<bool> setDiscoveryMode(bool enabled) async {
    try {
      return await _platform.invokeMethod('setDiscoveryMode', {'enabled': enabled});
    } on PlatformException {
      return false;
    }
  }

  Future<List<String>> getDiscoveredAids() async {
    try {
      final result = await _platform.invokeMethod('getDiscoveredAids');
      return result is List ? result.cast<String>() : [];
    } on PlatformException {
      return [];
    }
  }
}

final nfcServiceProvider = Provider<NfcService>((ref) => NfcService());