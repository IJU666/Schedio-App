import 'package:hive/hive.dart';
import '../models/tugas.dart';

class TugasController {
  final Box<Tugas> _tugasBox = Hive.box<Tugas>('tugasBox');

  List<Tugas> getAllTugas() {
    return _tugasBox.values.toList();
  }

  List<Tugas> getTugasByDate(DateTime date) {
    return _tugasBox.values.where((tugas) {
      return tugas.tanggal.year == date.year &&
          tugas.tanggal.month == date.month &&
          tugas.tanggal.day == date.day;
    }).toList();
  }

  List<Tugas> getTugasByMataKuliah(String mataKuliahId) {
    return _tugasBox.values
        .where((tugas) => tugas.mataKuliahId == mataKuliahId)
        .toList();
  }

  Future<void> addTugas(Tugas tugas) async {
    await _tugasBox.put(tugas.id, tugas);
  }

  Future<void> updateTugas(Tugas tugas) async {
    await tugas.save();
  }

  Future<void> deleteTugas(String id) async {
    await _tugasBox.delete(id);
  }

  Tugas? getTugasById(String id) {
    return _tugasBox.get(id);
  }

  Future<void> updateChecklistStatus(String tugasId, int index, bool status) async {
    final tugas = _tugasBox.get(tugasId);
    if (tugas != null) {
      tugas.checklistStatus[index] = status;
      await tugas.save();
    }
  }
}