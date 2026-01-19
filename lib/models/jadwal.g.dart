// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jadwal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JadwalAdapter extends TypeAdapter<Jadwal> {
  @override
  final int typeId = 2;

  @override
  Jadwal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Jadwal(
      id: fields[0] as String,
      mataKuliahId: fields[1] as String,
      hari: fields[2] as String,
      jamMulai: fields[3] as String,
      jamSelesai: fields[4] as String,
      ruangan: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Jadwal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mataKuliahId)
      ..writeByte(2)
      ..write(obj.hari)
      ..writeByte(3)
      ..write(obj.jamMulai)
      ..writeByte(4)
      ..write(obj.jamSelesai)
      ..writeByte(5)
      ..write(obj.ruangan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JadwalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
