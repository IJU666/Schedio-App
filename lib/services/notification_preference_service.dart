

import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferenceService {
  static final NotificationPreferenceService _instance = NotificationPreferenceService._();
  factory NotificationPreferenceService() => _instance;
  NotificationPreferenceService._();

  static const String _keyNotificationEnabled = 'notification_enabled';

  
  
  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationEnabled) ?? true; 
  }

  
  Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationEnabled, enabled);
    print('🔔 Notifikasi ${enabled ? "AKTIF" : "NONAKTIF"}');
  }

  
  Future<bool> toggleNotification() async {
    final currentStatus = await isNotificationEnabled();
    final newStatus = !currentStatus;
    await setNotificationEnabled(newStatus);
    return newStatus;
  }
}