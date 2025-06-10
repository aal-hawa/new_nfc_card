// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_aid.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiscoveredAidAdapter extends TypeAdapter<DiscoveredAid> {
  @override
  final int typeId = 1;

  @override
  DiscoveredAid read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiscoveredAid(
      aid: fields[0] as String,
      name: fields[1] as String?,
      scanCount: fields[2] as int,
      firstSeen: fields[3] as DateTime?,
      lastSeen: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DiscoveredAid obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.aid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.scanCount)
      ..writeByte(3)
      ..write(obj.firstSeen)
      ..writeByte(4)
      ..write(obj.lastSeen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveredAidAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
