// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tugas.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TugasAdapter extends TypeAdapter<Tugas> {
  @override
  final int typeId = 1;

  @override
  Tugas read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tugas(
      id: fields[0] as String,
      judul: fields[1] as String,
      mataKuliahId: fields[2] as String,
      mataKuliahNama: fields[3] as String,
      keterangan: fields[4] as String,
      isPrioritas: fields[5] as bool,
      tanggal: fields[6] as DateTime,
      setiapHari: fields[7] as bool,
      hariSebelumKelas: fields[8] as int,
      checklist: (fields[9] as List).cast<String>(),
      checklistStatus: (fields[10] as List).cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tugas obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.judul)
      ..writeByte(2)
      ..write(obj.mataKuliahId)
      ..writeByte(3)
      ..write(obj.mataKuliahNama)
      ..writeByte(4)
      ..write(obj.keterangan)
      ..writeByte(5)
      ..write(obj.isPrioritas)
      ..writeByte(6)
      ..write(obj.tanggal)
      ..writeByte(7)
      ..write(obj.setiapHari)
      ..writeByte(8)
      ..write(obj.hariSebelumKelas)
      ..writeByte(9)
      ..write(obj.checklist)
      ..writeByte(10)
      ..write(obj.checklistStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TugasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
