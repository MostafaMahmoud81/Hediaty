import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotification {


  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showBigTextNotification({
    required String userId, // Associate notification with a user
    var id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      'user_notifications_channel',
      'User Notifications',
      playSound: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    // Show the notification
    await fln.show(id, title, body, not);

  }

  static Future<void> showUnseenNotificationsForUser({
    required String userId,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    // Retrieve unseen notifications for the user
    List<Map<String, dynamic>> notifications = await getUnseenNotificationsForUser(userId);

    for (var notification in notifications) {
      await showBigTextNotification(
        userId: userId,
        title: notification['title']!,
        body: notification['body']!,
        fln: fln,
      );

      // Mark notification as seen
      await markNotificationAsSeen(userId, notification['id']);

      // Add a 2-second delay before showing the next notification
      await Future.delayed(const Duration(seconds: 7));
    }
  }


  static Future<void> saveNotificationForUser(String userId, String body) async {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .add({
        'title': "Hedieaty",
        'body': body,
        'seen': false, // Default to unseen
        'timestamp': FieldValue.serverTimestamp(),
      });
  }

  static Future<List<Map<String, dynamic>>> getUnseenNotificationsForUser(String userId) async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .where('seen', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'body': doc['body'],
        };
      }).toList();

  }

  static Future<void> markNotificationAsSeen(String userId, String notificationId) async {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .doc(notificationId)
          .update({'seen': true});
  }
}
