// lib/features/nfc_scan/data/nfc_repository.dart
import 'dart:async' show Completer;
import 'dart:math' show min;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nfc_card/features/aid_discovery/domain/discovered_aid.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/src/nfc_manager_android/pigeon.g.dart' show TagPigeon, NdefMessagePigeon;

class NfcRepository {
  late Box<Tag> _tagsBox;
  late Box<DiscoveredAid> _aidsBox;
  late Box _prefsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _tagsBox = await Hive.openBox<Tag>('nfc_tags_box');
    _aidsBox = await Hive.openBox<DiscoveredAid>('nfc_aids_box');
    _prefsBox = await Hive.openBox('preferences');
  }

  Future<void> saveTag(Tag tag) async => await _tagsBox.put(tag.id, tag);
  Future<void> deleteTag(String id) async => await _tagsBox.delete(id);
  Future<Tag?> getTagById(String id) async => await _tagsBox.get(id);
  Future<List<Tag>> getAllTags() async => _tagsBox.values.toList();

  Future<void> saveAid(DiscoveredAid aid) async => await _aidsBox.put(aid.aid, aid);
  DiscoveredAid? getAid(String aid) => _aidsBox.get(aid);
  List<DiscoveredAid> getAllAids() => _aidsBox.values.toList();

  Future<void> setSelectedTagId(String? id) async => await _prefsBox.put('selectedTagId', id);
  String? getSelectedTagId() => _prefsBox.get('selectedTagId');

  Future<void> close() async {
    await _tagsBox.close();
    await _aidsBox.close();
  }

  Future<Tag?> scanTag() async {
    final completer = Completer<Tag?>();
    
    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          await NfcManager.instance.stopSession();
          completer.complete(await _convertToTag(tag));
        },
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
      );
      return await completer.future;
    } catch (e) {
      completer.completeError(e);
      rethrow;
    }
  }

 Future<Tag> _convertToTag(NfcTag nfcTag) async {
  try {
    final tagPigeon = nfcTag.data as TagPigeon;
    final tagId = tagPigeon.id;
    
    // Extract additional information from the tag
    String? discoveredAid;
    List<String>? protocolSequence;
    String? payload;
    
    // Check if the tag has ISO-DEP technology
    final isoDep = tagPigeon.isoDep;
    if (isoDep != null) {
      discoveredAid = _extractAidFromTag(tagPigeon);
      protocolSequence = tagPigeon.techList;
    }
    
    // Extract payload from NDEF records if available
    if (tagPigeon.ndef?.cachedNdefMessage != null) {
      payload = _extractPayloadFromNdef(tagPigeon.ndef!.cachedNdefMessage!);
    }
    
    return Tag(
      id: tagId.isNotEmpty ? tagId.toString() : 'unknown_${DateTime.now().millisecondsSinceEpoch}',
      name: 'NFC Tag',
      savedAt: DateTime.now(),
      customAction: null,
      discoveredAid: discoveredAid,
      protocolSequence: protocolSequence,
      payload: payload,
    );
  } catch (e) {
    throw Exception('Failed to convert NFC tag: ${e.toString()}');
  }
}

// Helper method to extract payload from NDEF records
String? _extractPayloadFromNdef(NdefMessagePigeon ndefMessage) {
  try {
    // Combine payloads from all records
    final payloads = ndefMessage.records
        .where((record) => record.payload.isNotEmpty)
        .map((record) => String.fromCharCodes(record.payload))
        .toList();
    
    return payloads.isNotEmpty ? payloads.join('\n') : null;
  } catch (e) {
    return null;
  }
}

// Existing AID extraction method
String? _extractAidFromTag(TagPigeon tagPigeon) {
  try {
    final historicalBytes = tagPigeon.isoDep?.historicalBytes;
    if (historicalBytes != null && historicalBytes.isNotEmpty) {
      return historicalBytes.sublist(0, min(historicalBytes.length, 8)).join();
    }
    
    if (tagPigeon.ndef?.cachedNdefMessage != null) {
      for (final record in tagPigeon.ndef!.cachedNdefMessage!.records) {
        if (record.type.isNotEmpty) {
          return record.type.join();
        }
      }
    }
    
    return null;
  } catch (e) {
    return null;
  }
}
}

final nfcRepositoryProvider = Provider<NfcRepository>((ref) => NfcRepository());