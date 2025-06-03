// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      id: fields[0] as int,
      title: fields[1] as String,
      year: fields[2] as int,
      genres: (fields[3] as List).cast<String>(),
      rating: fields[4] as double,
      country: fields[5] as String,
      runtime: fields[6] as String,
      duration: fields[7] as String,
      overview: fields[8] as String,
      posterUrl: fields[9] as String,
      backdropUrl: fields[10] as String,
      trailerUrl: fields[11] as String?,
      actors: (fields[12] as List).cast<Actor>(),
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.genres)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.runtime)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.overview)
      ..writeByte(9)
      ..write(obj.posterUrl)
      ..writeByte(10)
      ..write(obj.backdropUrl)
      ..writeByte(11)
      ..write(obj.trailerUrl)
      ..writeByte(12)
      ..write(obj.actors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
