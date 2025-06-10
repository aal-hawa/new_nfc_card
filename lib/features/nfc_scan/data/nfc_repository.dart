// lib/features/nfc_scan/data/nfc_repository.dart
import 'dart:async' show Completer;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nfc_card/features/aid_discovery/domain/discovered_aid.dart';
import 'package:nfc_card/features/tag_management/domain/tag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart' ;
import 'package:nfc_manager/src/nfc_manager_android/pigeon.g.dart' show TagPigeon;
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart' show Ndef;

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

  // Tag operations
  Future<void> saveTag(Tag tag) => _tagsBox.put(tag.id, tag);
  Future<void> deleteTag(String id) => _tagsBox.delete(id);
   Future<Tag?> getTagById(String id) async {
    return _tagsBox.get(id);
  }
    Future<List<Tag>> getAllTags() async {
    return _tagsBox.values.toList();
  }

  // AID operations
  Future<void> saveAid(DiscoveredAid aid) => _aidsBox.put(aid.aid, aid);
  DiscoveredAid? getAid(String aid) => _aidsBox.get(aid);
  List<DiscoveredAid> getAllAids() => _aidsBox.values.toList();

  // Preferences
   Future<void> setSelectedTagId(String? id) async {
    await _prefsBox.put('selectedTagId', id);
  }
  
  String? getSelectedTagId() => _prefsBox.get('selectedTagId');

  Future<void> close() async {
    await _tagsBox.close();
    await _aidsBox.close();
  }

Future<TagPigeon> scanTag() async {
  final completer = Completer<TagPigeon>();
  try {
    await NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
      },
      onDiscovered: (NfcTag tag) async {
         final ndef = Ndef.from(tag);
          if (ndef != null) {
            final message = await ndef.read();
            // Process message here...
          }
        // completer.complete(TagPigeon.decode(tag.data));
        await NfcManager.instance.stopSession();
      },
    );
    return completer.future;
  } catch (e) {
    throw Exception('Failed to scan tag: $e');
  }
}
}

final nfcRepositoryProvider = Provider<NfcRepository>((ref) {
  throw UnimplementedError('Override this provider in main.dart');
});