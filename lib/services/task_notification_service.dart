// services/task_notification_service.dart
// ========================================
// TASK NOTIFICATION SERVICE - CROSS PLATFORM
// Menangani notifikasi pengingat deadline tugas
// ========================================

import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'notification_preference_service.dart';
import 'dart:io' show Platform;

class TaskNotificationService {
  static final TaskNotificationService _instance = TaskNotificationService._();
  factory TaskNotificationService() => _instance;
  TaskNotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationPreferenceService _preferenceService = NotificationPreferenceService();

  bool _initialized = false;

  /// Inisialisasi service notifikasi
  Future<void> initialize() async {
    if (_initialized) return;

    // Skip initialization untuk web
    if (kIsWeb) {
      print('⚠️ Task notifications tidak didukung di web browser');
      _initialized = true;
      return;
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    if (Platform.isAndroid) {
      await _requestPermissions();
    }

    _initialized = true;
    print('✅ TaskNotificationService initialized');
  }

  /// Request permissions untuk Android 13+
  Future<bool> _requestPermissions() async {
    if (kIsWeb) return false;
    
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.request();
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      return notificationStatus.isGranted && alarmStatus.isGranted;
    }
    return true;
  }

  /// Handler saat notifikasi ditap
  void _onNotificationTap(NotificationResponse response) {
    print('📱 Notifikasi tugas ditap: ${response.payload}');
  }

  /// Schedule semua notifikasi untuk satu tugas
  /// 4 notifikasi: 1 hari, 5 jam, 1 jam, 30 menit sebelum deadline
  Future<void> scheduleTaskNotifications({
    required String taskId,
    required String taskTitle,
    required String mataKuliahNama,
    required DateTime deadline,
  }) async {
    if (!_initialized) await initialize();

    // CEK TOGGLE PENGINGAT
    final isEnabled = await _preferenceService.isNotificationEnabled();
    if (!isEnabled) {
      print('⚠️ Notifikasi dinonaktifkan - Skip scheduling untuk $taskId');
    // Skip untuk web
    if (kIsWeb) {
      print('⚠️ Task notifications tidak tersedia di web');
      return;
    }

    try {
      // Cancel notifikasi lama jika ada
      await cancelTaskNotifications(taskId);

      final now = tz.TZDateTime.now(tz.local);
      final deadlineTime = tz.TZDateTime.from(deadline, tz.local);

      // Jika deadline sudah lewat, tidak schedule notifikasi
      if (deadlineTime.isBefore(now)) {
        print('⚠️ Deadline sudah lewat untuk tugas: $taskTitle');
        return;
      }

      // Daftar jadwal notifikasi
      final notificationSchedules = [
        {
          'offset': const Duration(days: 1),
          'title': '📚 Deadline Besok!',
          'body': '$taskTitle ($mataKuliahNama) - Deadline besok!',
          'id': 0,
        },
        {
          'offset': const Duration(hours: 5),
          'title': '⏰ 5 Jam Lagi!',
          'body': '$taskTitle ($mataKuliahNama) - Deadline 5 jam lagi',
          'id': 1,
        },
        {
          'offset': const Duration(hours: 1),
          'title': '🔔 1 Jam Lagi!',
          'body': '$taskTitle ($mataKuliahNama) - Deadline 1 jam lagi',
          'id': 2,
        },
        {
          'offset': const Duration(minutes: 30),
          'title': '⚡ 30 Menit Lagi!',
          'body': '$taskTitle ($mataKuliahNama) - Segera kumpulkan!',
          'id': 3,
        },
      ];

      int scheduledCount = 0;

      for (var schedule in notificationSchedules) {
        final notificationTime = deadlineTime.subtract(schedule['offset'] as Duration);

        // Hanya schedule jika waktu notifikasi masih di masa depan
        if (notificationTime.isAfter(now)) {
          final notificationId = _generateNotificationId(taskId, schedule['id'] as int);

          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            schedule['title'] as String,
            schedule['body'] as String,
            notificationTime,
            _notificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: '${taskId}_${schedule['id']}',
          );

          scheduledCount++;
          print('✅ Notifikasi $notificationId dijadwalkan pada $notificationTime');
        } else {
          print('⏭️ Skip notifikasi (waktu sudah lewat): ${schedule['title']}');
        }
      }

      print('🎯 Total $scheduledCount notifikasi dijadwalkan untuk: $taskTitle');
    } catch (e) {
      print('❌ Error scheduling task notifications: $e');
    }
  }

  /// Generate unique notification ID dari task ID dan schedule index
  int _generateNotificationId(String taskId, int scheduleIndex) {
    // Menggunakan hash code untuk ID unik, tambahkan offset 10000 untuk membedakan dari class notifications
    return ((taskId.hashCode & 0x7FFFFFFF) % 1000000) + (scheduleIndex * 1000000) + 10000;
  }

  /// Notification details untuk Android
  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'task_deadline_channel',
      'Pengingat Deadline Tugas',
      channelDescription: 'Notifikasi pengingat deadline tugas kuliah',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF7AB8FF),
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  /// Cancel semua notifikasi untuk satu tugas
  Future<void> cancelTaskNotifications(String taskId) async {
    if (kIsWeb) return;
    
    for (int i = 0; i < 4; i++) {
      final notificationId = _generateNotificationId(taskId, i);
      await _flutterLocalNotificationsPlugin.cancel(notificationId);
    }
    print('🗑️ Notifikasi dibatalkan untuk task: $taskId');
  }

  /// Cancel semua notifikasi tugas
  Future<void> cancelAllTaskNotifications() async {
    if (kIsWeb) return;
    
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('🗑️ Semua notifikasi tugas dibatalkan');
  }

  /// Get daftar notifikasi yang pending
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (kIsWeb) return [];
    
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Show test notification
  Future<void> showTestNotification() async {
    if (!_initialized) await initialize();

    if (kIsWeb) {
      print('⚠️ Test notification tidak tersedia di web');
      return;
    }

    await _flutterLocalNotificationsPlugin.show(
      888888,
      '🧪 Test Notifikasi Tugas',
      'Sistem notifikasi deadline tugas berfungsi dengan baik!',
      _notificationDetails(),
    );
  }

  /// Check permissions
  Future<bool> checkPermissions() async {
    if (kIsWeb) return false;
    
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.status;
      final alarmStatus = await Permission.scheduleExactAlarm.status;
      return notificationStatus.isGranted && alarmStatus.isGranted;
    }
    return true;
  }
  
  /// Helper method untuk cek apakah notifikasi tersedia
  bool get isSupported => !kIsWeb;
}