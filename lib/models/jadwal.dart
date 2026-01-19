import 'package:hive/hive.dart';

part 'jadwal.g.dart';

@HiveType(typeId: 2)
class Jadwal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String mataKuliahId;

  @HiveField(2)
  String hari;

  @HiveField(3)
  String jamMulai;

  @HiveField(4)
  String jamSelesai;

  @HiveField(5)
  String ruangan;

  Jadwal({
    required this.id,
    required this.mataKuliahId,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
  });
}