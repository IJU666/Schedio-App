import 'package:hive/hive.dart';

part 'tugas.g.dart';

@HiveType(typeId: 1)
class Tugas extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String judul;

  @HiveField(2)
  String mataKuliahId;

  @HiveField(3)
  String mataKuliahNama;

  @HiveField(4)
  String keterangan;

  @HiveField(5)
  bool isPrioritas;

  @HiveField(6)
  DateTime tanggal;

  @HiveField(7)
  bool setiapHari;

  @HiveField(8)
  int hariSebelumKelas;

  @HiveField(9)
  List<String> checklist;

  @HiveField(10)
  List<bool> checklistStatus;

  Tugas({
    required this.id,
    required this.judul,
    required this.mataKuliahId,
    required this.mataKuliahNama,
    required this.keterangan,
    required this.isPrioritas,
    required this.tanggal,
    required this.setiapHari,
    required this.hariSebelumKelas,
    required this.checklist,
    required this.checklistStatus,
  });
}