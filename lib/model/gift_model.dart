import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class Gift {
  int? id;
  String name;
  String? description;
  String? category;
  double? price;
  String status;
  int eventId;

  Gift({
    this.id,
    required this.name,
    this.description,
    this.category,
    this.price,
    required this.status,
    required this.eventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'event_id': eventId,
    };
  }

  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      status: map['status'],
      eventId: map['event_id'],
    );
  }
}

class GiftModel {
  final dbHelper = DatabaseHelper();

  Future<void> addGift(Map<String, dynamic> newGift, int eventId) async {
    final db = await dbHelper.database;

    await db.insert(
      'gifts',
      {
        'name': newGift['name'],
        'description': newGift['description'],
        'category': newGift['category'],
        'price': newGift['price'],
        'status': newGift['status'],
        'pledged': newGift['pledged'] ? 1 : 0, // Convert boolean to integer
        'event_id': eventId, // Ensure eventId is passed when calling the function
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle duplicates if needed
    );
  }


  Future<List<Map<String, dynamic>>> getGiftsForEvent(int eventId) async {
    final db = await dbHelper.database;

    const query = '''
    SELECT 
      id, 
      name, 
      description, 
      category, 
      price, 
      status, 
      pledged,
      event_id 
    FROM gifts
    WHERE event_id = ?
  ''';

    // Execute the query
    final result = await db.rawQuery(query, [eventId]);

    // Format the result into a list of maps
    final gifts = result.map((gift) {
      return {
        'id': gift['id'],
        'name': gift['name'],
        'description': gift['description'],
        'category': gift['category'],
        'price': gift['price'],
        'status': gift['status'],
        'pledged': (gift['pledged'] as int) == 1,
        'event_id': gift['event_id'],
      };
    }).toList();

    return gifts;
  }


  Future<int> updateGift(int giftId, Map<String, dynamic> updatedGift) async {
    final db = await dbHelper.database;

    final String name = updatedGift['name'];
    final String description = updatedGift['description'];
    final String category = updatedGift['category'];
    final double price = updatedGift['price'];
    final String status = updatedGift['status'];
    final bool pledged = updatedGift['pledged'];

    final Map<String, dynamic> updateData = {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'pledged': pledged ? 1 : 0, // Store boolean as integer
    };

    int result = await db.update(
      'gifts',
      updateData,
      where: 'id = ?',
      whereArgs: [giftId],
    );

    return result;
  }


  Future<int> deleteGift(int id) async {
    final db = await dbHelper.database;
    return db.delete('gifts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, String>>> getPledgedGifts(int userId) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT 
      gifts.name AS giftName,
      events.name AS event
    FROM gifts
    INNER JOIN events ON gifts.event_id = events.id
    WHERE events.user_id = ? AND gifts.pledged = 1;
  ''', [userId]);

    return results.map((row) {
      return {
        "giftName": row['giftName'] as String,
        "event": row['event'] as String,
      };
    }).toList();
  }

  Future<List<Map<String, String>>> getUserGifts(int userId) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT 
        gifts.name AS giftName,
        events.name AS event
      FROM gifts
      INNER JOIN events ON gifts.event_id = events.id
      WHERE events.user_id = ? ;
    ''', [userId]);

    return results.map((row) {
      return {
        "giftName": row['giftName'] as String,
        "event": row['event'] as String,
      };
    }).toList();
  }

  Future<void> updateGiftStatus(int giftId, String status, bool pledged) async {
    final db = await dbHelper.database;
      await db.update(
        'gifts',
        {
          'status': status,
          'pledged': pledged ? 1 : 0, // SQLite stores BOOLEAN as 1 (true) or 0 (false)
        },
        where: 'id = ?',
        whereArgs: [giftId],
      );
  }



}
