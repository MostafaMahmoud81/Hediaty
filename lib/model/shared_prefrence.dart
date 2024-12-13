import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefrence {

  // Singleton instance
  static final SharedPrefrence _instance = SharedPrefrence._internal();

  factory SharedPrefrence() {
    return _instance;
  }

  SharedPrefrence._internal();

  Future<bool> loadNotificationPreference(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isEnabled = prefs.getBool('notifications_$userId') ?? true;
    return isEnabled;
  }

  Future<void> saveNotificationPreference(bool isEnabled, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_$userId', isEnabled);
  }

}