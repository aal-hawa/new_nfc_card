// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagAdapter extends TypeAdapter<Tag> {
  @override
  final int typeId = 0;

  @override
  Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tag(
      id: fields[0] as String,
      name: fields[1] as String,
      payload: fields[2] as String?,
      customAction: fields[4] as String?,
      discoveredAid: fields[6] as String?,
      protocolSequence: (fields[7] as List?)?.cast<String>(),
      savedAt: fields[3] as DateTime?,
    )..isDefault = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.payload)
      ..writeByte(3)
      ..write(obj.savedAt)
      ..writeByte(4)
      ..write(obj.customAction)
      ..writeByte(5)
      ..write(obj.isDefault)
      ..writeByte(6)
      ..write(obj.discoveredAid)
      ..writeByte(7)
      ..write(obj.protocolSequence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
