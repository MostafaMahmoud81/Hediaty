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

  Future<int> insertGift(Gift gift) async {
    final db = await dbHelper.database;
    return db.insert('gifts', gift.toMap());
  }

  Future<List<Gift>> fetchGiftsByEvent(int eventId) async {
    final db = await dbHelper.database;
    final gifts = await db.query('gifts', where: 'event_id = ?', whereArgs: [eventId]);
    return gifts.map((g) => Gift.fromMap(g)).toList();
  }

  Future<int> updateGift(Gift gift) async {
    final db = await dbHelper.database;
    return db.update('gifts', gift.toMap(), where: 'id = ?', whereArgs: [gift.id]);
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

}
