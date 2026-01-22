import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import '../models/jadwal.dart';
import '../models/mata_kuliah.dart';

class ClassNotificationService {
  static final ClassNotificationService _instance = ClassNotificationService._();
  factory ClassNotificationService() => _instance;
  ClassNotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

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
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.request();
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      return notificationStatus.isGranted && alarmStatus.isGranted;
    }
    return true;
  }

  void _onNotificationTap(NotificationResponse response) {
    print('Notifikasi ditap: ${response.payload}');
  }

  Future<void> scheduleAllNotificationsForClass(String jadwalId) async {
    if (!_initialized) await initialize();

    try {
      final jadwalBox = Hive.box<Jadwal>('jadwalBox');
      final mataKuliahBox = Hive.box<MataKuliah>('mataKuliahBox');
      
      final jadwal = jadwalBox.values.cast<Jadwal>().firstWhere(
        (j) => j.id == jadwalId,
        orElse: () => throw Exception('Jadwal tidak ditemukan'),
      );
      
      final mataKuliah = mataKuliahBox.values.cast<MataKuliah>().firstWhere(
        (mk) => mk.id == jadwal.mataKuliahId,
        orElse: () => throw Exception('Mata kuliah tidak ditemukan'),
      );

      await cancelNotificationsForClass(jadwalId);

      final classDateTime = _getNextClassDateTime(jadwal.hari, jadwal.jamMulai);
      final now = tz.TZDateTime.now(tz.local);
      final classTime = tz.TZDateTime.from(classDateTime, tz.local);

      if (classTime.isBefore(now)) {
        print('Waktu kelas sudah lewat untuk ${mataKuliah.nama}');
        return;
      }

      final notificationSchedules = [
        {
          'offset': const Duration(days: 1),
          'title': '📚 Besok Ada Kelas!',
          'body': '${mataKuliah.nama} besok pukul ${jadwal.jamMulai} - ${jadwal.jamSelesai}',
          'id': 0,
        },
        {
          'offset': const Duration(minutes: 60),
          'title': '⏰ Kelas 1 Jam Lagi',
          'body': '${mataKuliah.nama} dimulai pukul ${jadwal.jamMulai}',
          'id': 1,
        },
        {
          'offset': const Duration(minutes: 30),
          'title': '⚡ Kelas 30 Menit Lagi',
          'body': '${mataKuliah.nama} pukul ${jadwal.jamMulai}. Bersiap-siap!',
          'id': 2,
        },
        {
          'offset': const Duration(minutes: 10),
          'title': '🔔 Kelas 10 Menit Lagi!',
          'body': '${mataKuliah.nama} segera dimulai. Jangan terlambat!',
          'id': 3,
        },
        {
          'offset': Duration.zero,
          'title': '🎓 Kelas Dimulai Sekarang!',
          'body': '${mataKuliah.nama} sedang berlangsung',
          'id': 4,
        },
      ];

      for (var schedule in notificationSchedules) {
        final notificationTime = classTime.subtract(schedule['offset'] as Duration);

        if (notificationTime.isAfter(now)) {
          final notificationId = _generateNotificationId(jadwalId, schedule['id'] as int);

          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            schedule['title'] as String,
            schedule['body'] as String,
            notificationTime,
            _notificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: '${jadwalId}_${schedule['id']}',
          );

          print('✅ Notifikasi dijadwalkan: $notificationId pada $notificationTime');
        }
      }
    } catch (e) {
      print('❌ Error scheduling notifications: $e');
    }
  }

  DateTime _getNextClassDateTime(String dayName, String jamMulai) {
    final now = DateTime.now();
    final targetDay = _getNextDayOfWeek(dayName);
    final timeParts = jamMulai.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    DateTime classDateTime = DateTime(
      targetDay.year,
      targetDay.month,
      targetDay.day,
      hour,
      minute,
    );

    if (classDateTime.isBefore(now)) {
      classDateTime = classDateTime.add(const Duration(days: 7));
    }

    return classDateTime;
  }

  DateTime _getNextDayOfWeek(String dayName) {
    final now = DateTime.now();
    final targetWeekday = _getDayNumber(dayName);
    final currentWeekday = now.weekday;

    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd < 0) {
      daysToAdd += 7;
    }

    return now.add(Duration(days: daysToAdd));
  }

  int _getDayNumber(String dayName) {
    const days = {
      'Senin': 1,
      'Selasa': 2,
      'Rabu': 3,
      'Kamis': 4,
      'Jumat': 5,
      'Sabtu': 6,
      'Minggu': 7,
    };
    return days[dayName] ?? 1;
  }

  int _generateNotificationId(String classId, int scheduleIndex) {
    return (classId.hashCode & 0x7FFFFFFF) + scheduleIndex;
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'class_reminder_channel',
      'Pengingat Jadwal Kelas',
      channelDescription: 'Notifikasi pengingat jadwal kelas kuliah',
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

  Future<void> cancelNotificationsForClass(String classId) async {
    for (int i = 0; i < 5; i++) {
      final notificationId = _generateNotificationId(classId, i);
      await _flutterLocalNotificationsPlugin.cancel(notificationId);
    }
    print('🗑️ Notifikasi dibatalkan untuk class: $classId');
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('🗑️ Semua notifikasi dibatalkan');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> showTestNotification() async {
    if (!_initialized) await initialize();

    await _flutterLocalNotificationsPlugin.show(
      999999,
      '🧪 Test Notifikasi',
      'Ini adalah notifikasi percobaan. Jika muncul, sistem berfungsi dengan baik!',
      _notificationDetails(),
    );
  }

  Future<bool> checkPermissions() async {
    if (Platform.isAndroid) {
      final notificationStatus = await Permission.notification.status;
      final alarmStatus = await Permission.scheduleExactAlarm.status;
      return notificationStatus.isGranted && alarmStatus.isGranted;
    }
    return true;
  }
}