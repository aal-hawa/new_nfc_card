// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'features/nfc_scan/data/nfc_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    final nfcRepository = NfcRepository();
    await nfcRepository.init();

    runApp(
      ProviderScope(
        overrides: [
          nfcRepositoryProvider.overrideWithValue(nfcRepository),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e\n$stackTrace');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Initialization failed: ${e.toString()}')),
        ),
      ),
    );
  }
}