// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dolphin_assignment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DolphinAssignmentAdapter extends TypeAdapter<DolphinAssignment> {
  @override
  final int typeId = 4;

  @override
  DolphinAssignment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DolphinAssignment(
      assetPath: fields[0] as String,
      scale: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DolphinAssignment obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.assetPath)
      ..writeByte(1)
      ..write(obj.scale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DolphinAssignmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
