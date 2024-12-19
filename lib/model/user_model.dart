import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../services/firebase_service.dart';
import 'database_helper.dart';

class Userr {
  int? id;
  String name;
  String email;
  String phone;
  String? preferences;

  Userr({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.preferences,
  });

  // Convert User object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'preferences': preferences,
    };
  }

  factory Userr.fromMap(Map<String, dynamic> map) {
    return Userr(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      preferences: map['preferences'],
    );
  }

}


class UserModel {
  final dbHelper = DatabaseHelper();
  final fireBase = FirebaseService();

  Future<int> insertUser(Userr user) async {
    final db = await dbHelper.database;
    return db.insert(
      'users',
      {
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
      },
    );
  }

  Future<Userr?> getUserByEmail(String email) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return Userr.fromMap(result.first);
    }
    return null;
  }

  Future<int?> getUserIdByEmail(String email) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  Future<int?> getUserIdByPhone(String phone) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      columns: ['id'],
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  Future<String?> getNameByUserId(int userId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first['name'] as String;
    }
    return null; // Return null if no user is found
  }

  Future<String?> getEmailByUserId(int userId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      columns: ['email'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first['email'] as String;
    }
    return null; // Return null if no user is found
  }


  Future<Map<String, String>> getUserData(int userId) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return {
        'name': result[0]['name'],
        'email': result[0]['email'],
        'phone': result[0]['phone'],
      };
    }
    return {};
  }


  Future<int> updateUserData(int userId, String name, String phone) async {
    final db = await dbHelper.database;

    return await db.update(
      'users',
      {'name': name, 'phone': phone},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> getUserIdByName(String name) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
    );

    return result.first['id'] as int;

  }

  Future<void> signOut()async {
    await fireBase.signOut();
  }



  Future<void> storeNotification(String userId, String message) async {
    final notificationsCollection = FirebaseFirestore.instance.collection('notifications');

    await notificationsCollection.add({
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isSeen': false,
    });
  }

  Future<void> showUnseenNotifications(String userId) async {
    final notificationsCollection = FirebaseFirestore.instance.collection('notifications');

    // Query unseen notifications for the specific user
    final querySnapshot = await notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      final notification = doc.data();

      // Get notification ID and message
      final String notificationId = doc.id;
      final String message = notification['message'] as String;

      // Show the notification
      await showLocalNotification(message);

      // Mark the notification as seen
      await markNotificationAsSeen(notificationId);
    }
  }

  Future<void> markNotificationAsSeen(String notificationId) async {
    final notificationsCollection = FirebaseFirestore.instance.collection('notifications');

    await notificationsCollection.doc(notificationId).update({
      'isSeen': true,
    });
  }

  static Future showLocalNotification(String msg) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print("hi");

    var androidDetails = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'This is a notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Notification',
      msg,
      platformDetails,
      payload: 'Notification Payload',
    );
  }


  // Future<void> showLocalNotification(int notificationId, String message) async {
  //
  //   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   // FlutterLocalNotificationsPlugin();
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   FlutterLocalNotificationsPlugin();
  //
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   const InitializationSettings initializationSettings =
  //   InitializationSettings(android: initializationSettingsAndroid);
  //
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //
  //
  //   print("joee");
  //
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'user_action_channel',
  //     'User Actions',
  //     channelDescription: 'Notifications for user actions',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidDetails);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     notificationId,
  //     'New Notification',
  //     message,
  //     notificationDetails,
  //   );
  // }





// Future<void> storeNotification(int userId, String message) async {
  //   final db = await dbHelper.database;
  //   await db.insert('Notifications', {
  //     'userId': userId,
  //     'message': message,
  //     'timestamp': DateTime.now().toString(),
  //     'isSeen': 0,
  //   });
  // }
  //
  // Future<void> showUnseenNotifications(int userId) async {
  //   final db = await dbHelper.database;
  //
  //   // Query unseen notifications for the specific user
  //   final notifications = await db.query(
  //     'Notifications',
  //     where: 'isSeen = ? AND userId = ?',
  //     whereArgs: [0, userId],
  //   );
  //
  //   for (var notification in notifications) {
  //     // Explicitly cast 'id' to an int
  //     final int notificationId = notification['id'] as int;
  //
  //     // Ensure 'message' is cast to String
  //     final String message = notification['message'].toString();
  //
  //     // Show the notification
  //     await showLocalNotification(notificationId, message);
  //
  //     // Mark the notification as seen
  //     await markNotificationAsSeen(notificationId);
  //   }
  // }
  //
  //
  //
  // Future<void> markNotificationAsSeen(int notificationId) async {
  //   final db = await dbHelper.database;
  //   await db.update(
  //     'Notifications',
  //     {'isSeen': 1},
  //     where: 'id = ?',
  //     whereArgs: [notificationId],
  //   );
  // }
  //
  // Future<void> showLocalNotification(int notificationId, String message) async {
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   FlutterLocalNotificationsPlugin();
  //
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'user_action_channel',
  //     'User Actions',
  //     channelDescription: 'Notifications for user actions',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidDetails);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     notificationId,
  //     'New Notification',
  //     message,
  //     notificationDetails,
  //   );
  // }



}

