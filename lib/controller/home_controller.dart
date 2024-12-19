import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/services/notification.dart';
import '../model/user_model.dart';
import '../model/friend_model.dart';
import '../model/shared_prefrence.dart';

class HomeController {

  final TextEditingController searchController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final UserModel userModel = UserModel();
  final FriendModel friendModel = FriendModel();
  final SharedPrefrence sharedPrefrence = SharedPrefrence();

  bool isNotificationsEnabled = true;

  late int userId;
  late int friendId;

  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> filteredFriends = [];


  Future<void> showUnseenNotifications(String userId, FlutterLocalNotificationsPlugin fln) async {
    await LocalNotification.showUnseenNotificationsForUser(userId: userId,fln: fln);
  }

  Future<List<Map<String, dynamic>>> getFriends(int id) async {
    List<Map<String, dynamic>> friends = await friendModel.getFriendsWithUpcomingEvents(id);
    return friends;
  }

  Future<int> addFriend(int userId, int friendId) async {
    final result = await friendModel.addFriend(userId, friendId);
    phoneController.clear();
    return result;
  }

  Future<int> getUserIdByName(String name) async {
    final result = await userModel.getUserIdByName(name);
    return result;
  }

  Future<void> signOut()async {
    await userModel.signOut();
  }

  Future<bool> loadNotificationPreference(int userId) async{
    bool isEnabled = await sharedPrefrence.loadNotificationPreference(userId);
    return isEnabled;
  }

}