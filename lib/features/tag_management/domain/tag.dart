// lib/features/tag_management/domain/tag.dart
import 'package:hive/hive.dart';

part 'tag.g.dart';

@HiveType(typeId: 0)
class Tag {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String? payload;
  
  @HiveField(3)
  final DateTime savedAt;
  
  @HiveField(4)
  String? customAction;
  
  @HiveField(5)
  bool isDefault = false;

  @HiveField(6)
  String? discoveredAid;

  @HiveField(7)
  List<String>? protocolSequence;

  Tag copyWith({
      String? id,
      String? name,
      String? payload,
      String? customAction,
      bool? isDefault,
      String? discoveredAid,
      List<String>? protocolSequence,
    }) {
      return Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        payload: payload ?? this.payload,
        customAction: customAction ?? this.customAction,
        discoveredAid: discoveredAid ?? this.discoveredAid,
        protocolSequence: protocolSequence ?? this.protocolSequence,
        savedAt: this.savedAt,
      )..isDefault = isDefault ?? this.isDefault;
    }
    
  Tag({
    required this.id,
    required this.name,
    this.payload,
    this.customAction,
    this.discoveredAid,
    this.protocolSequence,
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();
}