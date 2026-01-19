import 'package:hive/hive.dart';
import '../models/mata_kuliah.dart';

class MataKuliahController {
  final Box<MataKuliah> _mataKuliahBox = Hive.box<MataKuliah>('mataKuliahBox');

  List<MataKuliah> getAllMataKuliah() {
    return _mataKuliahBox.values.toList();
  }

  Future<void> addMataKuliah(MataKuliah mataKuliah) async {
    await _mataKuliahBox.put(mataKuliah.id, mataKuliah);
  }

  Future<void> updateMataKuliah(MataKuliah mataKuliah) async {
    await mataKuliah.save();
  }

  Future<void> deleteMataKuliah(String id) async {
    await _mataKuliahBox.delete(id);
  }

  MataKuliah? getMataKuliahById(String id) {
    return _mataKuliahBox.get(id);
  }
}