// lib/features/aid_discovery/domain/discovered_aid.dart
import 'package:hive/hive.dart';

part 'discovered_aid.g.dart';

@HiveType(typeId: 1)
class DiscoveredAid {
  @HiveField(0)
  final String aid;
  
  @HiveField(1)
  String? name;
  
  @HiveField(2)
  int scanCount;
  
  @HiveField(3)
  DateTime firstSeen;
  
  @HiveField(4)
  DateTime lastSeen;

 DiscoveredAid copyWith({
    String? aid,
    String? name,
    int? scanCount,
    DateTime? firstSeen,
    DateTime? lastSeen,
  }) {
    return DiscoveredAid(
      aid: aid ?? this.aid,
      name: name ?? this.name,
      scanCount: scanCount ?? this.scanCount,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
  
  DiscoveredAid({
    required this.aid,
    this.name,
    this.scanCount = 1,
    DateTime? firstSeen,
    DateTime? lastSeen,
  }) : firstSeen = firstSeen ?? DateTime.now(),
       lastSeen = lastSeen ?? DateTime.now();

  @override
  String toString() {
    return name != null ? '$name ($aid)' : aid;
  }
}