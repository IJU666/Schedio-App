// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mata_kuliah.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MataKuliahAdapter extends TypeAdapter<MataKuliah> {
  @override
  final int typeId = 0;

  @override
  MataKuliah read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MataKuliah(
      id: fields[0] as String,
      kode: fields[1] as String,
      nama: fields[2] as String,
      ruangan: fields[3] as String,
      sks: fields[4] as int,
      dosen: fields[5] as String,
      warna: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MataKuliah obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.kode)
      ..writeByte(2)
      ..write(obj.nama)
      ..writeByte(3)
      ..write(obj.ruangan)
      ..writeByte(4)
      ..write(obj.sks)
      ..writeByte(5)
      ..write(obj.dosen)
      ..writeByte(6)
      ..write(obj.warna);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MataKuliahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
