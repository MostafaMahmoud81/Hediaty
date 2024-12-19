import 'database_helper.dart';


class FriendModel {
  final dbHelper = DatabaseHelper();

  Future<int> addFriend(int userId, int friendId) async {
    if(userId != friendId) {
      final db = await dbHelper.database;
      return db.insert('friends', {'user_id': userId, 'friend_id': friendId});
    }
    else{
      return -1;
    }
  }

  Future<List<int>> fetchFriendsByUser(int userId) async {
    final db = await dbHelper.database;
    final friends = await db.query('friends', where: 'user_id = ?', whereArgs: [userId]);
    return friends.map((f) => f['friend_id'] as int).toList();
  }

  Future<int> removeFriend(int userId, int friendId) async {
    final db = await dbHelper.database;
    return db.delete('friends', where: 'user_id = ? AND friend_id = ?', whereArgs: [userId, friendId]);
  }

  Future<List<Map<String, dynamic>>> getFriendsWithUpcomingEvents(int userId) async {
    final db = await dbHelper.database;
    const query = '''
    SELECT 
      u.id AS friendId,
      u.name AS name,
      u.phone AS phone,
      COUNT(e.id) AS events
    FROM friends f
    INNER JOIN users u ON u.id = f.friend_id
    LEFT JOIN events e ON e.user_id = u.id AND e.status = 'Upcoming'
    WHERE f.user_id = ?
    GROUP BY u.id
  ''';

    final result = await db.rawQuery(query, [userId]);

    return result.map((row) => {
      'friendId': row['friendId'],
      'name': row['name'],
      'phone': row['phone'],
      'events': row['events'] ?? 0,
    }).toList();
  }

}
