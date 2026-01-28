import 'package:hive/hive.dart';

part 'mata_kuliah.g.dart';

@HiveType(typeId: 0)
class MataKuliah extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String kode;

  @HiveField(2)
  String nama;

  @HiveField(3)
  String ruangan;

  @HiveField(4)
  int sks;

  @HiveField(5)
  String dosen;

  @HiveField(6)
  String warna; 

  MataKuliah({
    required this.id,
    required this.kode,
    required this.nama,
    required this.ruangan,
    required this.sks,
    required this.dosen,
    this.warna = '#7AB8FF',
  });
}