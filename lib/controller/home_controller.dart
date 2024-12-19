import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../model/friend_model.dart';

class HomeController {

  final TextEditingController searchController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final UserModel userModel = UserModel();
  final FriendModel friendModel = FriendModel();

  late int userId;
  late int friendId;

  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> filteredFriends = [];


  Future<void> showUnseenNotifications(String userId) async {
    await userModel.showUnseenNotifications(userId);
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

}