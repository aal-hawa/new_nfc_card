// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:nfc_card/app/routes.dart';
import 'package:nfc_card/features/aid_discovery/presentation/aid_discovery_page.dart';
import 'package:nfc_card/features/aid_discovery/presentation/aids_page.dart';
import 'package:nfc_card/features/settings/presentation/about_page.dart';
import 'package:nfc_card/features/settings/presentation/home_page.dart';
import 'package:nfc_card/features/nfc_scan/presentation/scan_page.dart';
import 'package:nfc_card/features/tag_management/presentation/saved_tags_page.dart';
import 'package:nfc_card/features/tag_management/presentation/tag_detail_page.dart';
import 'package:nfc_card/features/tag_sharing/presentation/tag_sharing_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Card Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.scan: (context) => const ScanPage(),
        AppRoutes.savedTags: (context) => const SavedTagsPage(),
        AppRoutes.tagDetail: (context) => const TagDetailPage(),
        AppRoutes.tagSharing: (context) => const TagSharingPage(),
        AppRoutes.about: (context) => const AboutPage(),
        AppRoutes.aids: (context) => const AidsPage(),
        AppRoutes.aidDiscovery: (context) => const AidDiscoveryPage(),
      },
    );
  }
}