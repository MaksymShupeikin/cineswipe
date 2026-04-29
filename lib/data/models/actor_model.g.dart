// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActorAdapter extends TypeAdapter<Actor> {
  @override
  final typeId = 1;

  @override
  Actor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Actor(name: fields[0] as String, profileUrl: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, Actor obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.profileUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
