import 'package:flutter/material.dart';
import '../model/event_model.dart';
import '../model/gift_model.dart';
import '../model/shared_prefrence.dart';
import '../model/user_model.dart';

class ProfileController {

  final UserModel userModel = UserModel();
  final EventModel eventModel = EventModel();
  final GiftModel giftModel = GiftModel();
  final SharedPrefrence sharedPrefrence = SharedPrefrence();

  late TextEditingController nameController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  bool isEditingName = false;
  bool isEditingPhone = false;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }
    if (!RegExp(r'^01[0-9]{9}$').hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  Future<String?> getUserName(int id) async {
    String? userName = await userModel.getNameByUserId(id);
    if(userName != null) {
      return userName;
    }
    else{
      return null;
    }
  }

  Future<String?> getEmail(int id) async {
    String? email = await userModel.getEmailByUserId(id);
    if(email != null) {
      return email;
    }
    else{
      return null;
    }
  }

  Future<List<Map<String, String>>> getEvents(int id) async {
    List<Map<String, String>> events = await eventModel.getEventsForUser(id);
      return events;
  }

  Future<List<Map<String, String>>> getPledgedGifts(int id) async {
    List<Map<String, String>> gifts = await giftModel.getPledgedGifts(id);
    return gifts;
  }

  Future<List<Map<String, String>>> getUserGifts(int id) async {
    List<Map<String, String>> gifts = await giftModel.getUserGifts(id);
    return gifts;
  }

  Future<Map<String, String>> getUserData(int userId) async {
    final Map<String, String> result = await userModel.getUserData(userId);
    return result;
  }

  Future<int> updateUserData(int userId) async {
    final updatedName = nameController.text;
    final updatedPhone = phoneController.text;

    int result = await userModel.updateUserData(userId, updatedName, updatedPhone);
    return result;
  }

  Future<bool> loadNotificationPreference(int userId) async{
    bool isEnabled = await sharedPrefrence.loadNotificationPreference(userId);
    return isEnabled;
  }

  void saveNotificationPreference(bool isEnabled, int userId) async{
    await sharedPrefrence.saveNotificationPreference(isEnabled, userId);
  }


}
