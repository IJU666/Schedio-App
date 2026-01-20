import 'package:hive/hive.dart';
import '../models/jadwal.dart';

class JadwalController {
  final Box<Jadwal> _jadwalBox = Hive.box<Jadwal>('jadwalBox');

  List<Jadwal> getAllJadwal() {
    return _jadwalBox.values.toList();
  }

  List<Jadwal> getJadwalByHari(String hari) {
    return _jadwalBox.values
        .where((jadwal) => jadwal.hari == hari)
        .toList();
  }

  List<Jadwal> getJadwalByMataKuliah(String mataKuliahId) {
    return _jadwalBox.values
        .where((jadwal) => jadwal.mataKuliahId == mataKuliahId)
        .toList();
  }

  Future<void> addJadwal(Jadwal jadwal) async {
    await _jadwalBox.put(jadwal.id, jadwal);
  }

  Future<void> updateJadwal(Jadwal jadwal) async {
    await jadwal.save();
  }

  Future<void> deleteJadwal(String id) async {
    await _jadwalBox.delete(id);
  }

  Jadwal? getJadwalById(String id) {
    return _jadwalBox.get(id);
  }
}