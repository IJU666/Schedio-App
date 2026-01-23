// services/notification_preference_service.dart
// ========================================
// NOTIFICATION PREFERENCE SERVICE
// Mengelola pengaturan pengingat (on/off)
// ========================================

import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferenceService {
  static final NotificationPreferenceService _instance = NotificationPreferenceService._();
  factory NotificationPreferenceService() => _instance;
  NotificationPreferenceService._();

  static const String _keyNotificationEnabled = 'notification_enabled';

  /// Check apakah notifikasi diaktifkan
  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationEnabled) ?? true; // Default: enabled
  }

  /// Set status notifikasi (aktif/nonaktif)
  Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationEnabled, enabled);
    print('🔔 Notifikasi ${enabled ? "AKTIF" : "NONAKTIF"}');
  }

  /// Toggle status notifikasi
  Future<bool> toggleNotification() async {
    final currentStatus = await isNotificationEnabled();
    final newStatus = !currentStatus;
    await setNotificationEnabled(newStatus);
    return newStatus;
  }
}