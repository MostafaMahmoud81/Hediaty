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


  // Future<void> saveImagePathForGift(String imagePath, String giftId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   Map<String, String> giftImages = {};
  //   String? savedData = prefs.getString('gift_images');
  //   if (savedData != null) {
  //     giftImages = Map<String, String>.from(json.decode(savedData));
  //   }
  //
  //   giftImages[giftId] = imagePath;
  //
  //   await prefs.setString('gift_images', json.encode(giftImages));
  // }
  //
  //
  // Future<String?> loadImagePathForGift(String giftId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   String? savedData = prefs.getString('gift_images');
  //
  //     Map<String, String> giftImages = Map<String, String>.from(json.decode(savedData!));
  //     return giftImages[giftId];
  //
  // }



}