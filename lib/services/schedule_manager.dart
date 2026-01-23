import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import '../models/jadwal.dart';
import 'notification_service.dart';
import 'notification_preference_service.dart';

class ScheduleManager {
  static final ScheduleManager _instance = ScheduleManager._();
  factory ScheduleManager() => _instance;
  ScheduleManager._();

  final ClassNotificationService _notificationService = ClassNotificationService();
  final NotificationPreferenceService _preferenceService = NotificationPreferenceService();

  Future<void> initialize() async {
    await _notificationService.initialize();
    await resyncAllNotifications();
  }

  Future<void> addSchedule(String jadwalId) async {
    await _notificationService.scheduleAllNotificationsForClass(jadwalId);
    print('✅ Jadwal ditambahkan dengan notifikasi: $jadwalId');
  }

  Future<void> removeSchedule(String jadwalId) async {
    await _notificationService.cancelNotificationsForClass(jadwalId);
    print('🗑️ Jadwal dihapus: $jadwalId');
  }

  Future<void> updateSchedule(String jadwalId) async {
    await removeSchedule(jadwalId);
    await addSchedule(jadwalId);
    print('🔄 Jadwal diupdate: $jadwalId');
  }

  Future<void> resyncAllNotifications() async {
    print('🔄 Menyinkronkan ulang semua notifikasi kelas...');
    
    // CEK TOGGLE PENGINGAT
    final isEnabled = await _preferenceService.isNotificationEnabled();
    if (!isEnabled) {
      print('⚠️ Notifikasi dinonaktifkan - Cancel semua notifikasi kelas');
      await _notificationService.cancelAllNotifications();
      return;
    }
    
    await _notificationService.cancelAllNotifications();
    
    final jadwalBox = Hive.box<Jadwal>('jadwalBox');
    final allSchedules = jadwalBox.values.cast<Jadwal>().toList();
    
    for (var jadwal in allSchedules) {
      try {
        await _notificationService.scheduleAllNotificationsForClass(jadwal.id);
      } catch (e) {
        print('❌ Error scheduling notification for ${jadwal.id}: $e');
      }
    }
    
    print('✅ Sinkronisasi selesai untuk ${allSchedules.length} jadwal');
  }

  Future<int> getPendingNotificationCount() async {
    final pending = await _notificationService.getPendingNotifications();
    return pending.length;
  }

  Future<List<PendingNotificationRequest>> getPendingNotificationDetails() async {
    return await _notificationService.getPendingNotifications();
  }

  Future<void> showTestNotification() async {
    await _notificationService.showTestNotification();
  }

  Future<bool> checkPermissions() async {
    return await _notificationService.checkPermissions();
  }
}