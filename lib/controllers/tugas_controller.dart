// controllers/tugas_controller.dart
// ========================================
// TUGAS CONTROLLER - DENGAN INTEGRASI NOTIFIKASI
// ========================================

import 'package:hive/hive.dart';
import '../models/tugas.dart';
import '../services/task_notification_service.dart';
import '../services/notification_preference_service.dart';

class TugasController {
  final Box<Tugas> _tugasBox = Hive.box<Tugas>('tugasBox');
  final TaskNotificationService _notificationService = TaskNotificationService();
  final NotificationPreferenceService _preferenceService = NotificationPreferenceService();

  
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
    
    
    await _notificationService.scheduleTaskNotifications(
      taskId: tugas.id,
      taskTitle: tugas.judul,
      mataKuliahNama: tugas.mataKuliahNama,
      deadline: tugas.tanggal,
    );
    
    print('✅ Tugas ditambahkan dengan notifikasi: ${tugas.judul}');
  }

  
  Future<void> updateTugas(Tugas tugas) async {
    await tugas.save();
    
    
    await _notificationService.scheduleTaskNotifications(
      taskId: tugas.id,
      taskTitle: tugas.judul,
      mataKuliahNama: tugas.mataKuliahNama,
      deadline: tugas.tanggal,
    );
    
    print('🔄 Tugas diupdate dengan notifikasi: ${tugas.judul}');
  }

  
  Future<void> deleteTugas(String id) async {
    
    await _notificationService.cancelTaskNotifications(id);
    
    
    await _tugasBox.delete(id);
    
    print('🗑️ Tugas dihapus beserta notifikasinya: $id');
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

  Future<void> initializeNotifications() async {
    await _notificationService.initialize();
  }

  
  Future<void> resyncAllTaskNotifications() async {
    print('🔄 Menyinkronkan ulang notifikasi tugas...');
    
    
    final isEnabled = await _preferenceService.isNotificationEnabled();
    if (!isEnabled) {
      print('⚠️ Notifikasi dinonaktifkan - Cancel semua notifikasi tugas');
      await _notificationService.cancelAllTaskNotifications();
      return;
    }
    
    final allTugas = getAllTugas();
    int successCount = 0;
    
    for (var tugas in allTugas) {
      try {
        await _notificationService.scheduleTaskNotifications(
          taskId: tugas.id,
          taskTitle: tugas.judul,
          mataKuliahNama: tugas.mataKuliahNama,
          deadline: tugas.tanggal,
        );
        successCount++;
      } catch (e) {
        print('❌ Error resyncing notification for ${tugas.judul}: $e');
      }
    }
    
    print('✅ Sinkronisasi selesai: $successCount/${allTugas.length} tugas');
  }

  
  Future<int> getPendingNotificationCount() async {
    final pending = await _notificationService.getPendingNotifications();
    return pending.length;
  }

  
  Future<void> showTestNotification() async {
    await _notificationService.showTestNotification();
  }

  
  Future<bool> checkNotificationPermissions() async {
    return await _notificationService.checkPermissions();
  }
}