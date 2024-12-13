import 'gift_model.dart';
import 'database_helper.dart';


class Event {
  int? id;
  String name;
  DateTime date;  // Ensure you have a DateTime field for the event's date
  String category;
  String? location;
  String? description;
  List<Gift> gifts;  // List of gifts associated with this event

  Event({
    this.id,
    required this.name,
    required this.date,  // Required field for date
    required this.category,
    this.location,
    this.description,
    this.gifts = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'category': category,// Convert date to a string for storage
      'location': location,
      'description': description,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),  // Convert string back to DateTime
      category: map['category'],
      location: map['location'],
      description: map['description'],
      gifts: [],  // Initialize empty gifts, will be handled separately
    );
  }
}




class EventModel {
  final dbHelper = DatabaseHelper();



  Future<int> insertEvent(Event event) async {
    final db = await dbHelper.database;
    int eventId = await db.insert('events', event.toMap());
    for (Gift gift in event.gifts) {
      gift.eventId = eventId;
      await db.insert('gifts', gift.toMap());
    }
    return eventId;
  }


  // Fetch all events, optionally sorted by a specific column
  Future<List<Event>> fetchAllEvents({String? sortBy}) async {
    final db = await dbHelper.database;

    // Define the order by clause based on the sorting parameter
    String orderBy = '';
    if (sortBy == 'name') {
      orderBy = 'name ASC';
    } else if (sortBy == 'date') {
      orderBy = 'date ASC';
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      orderBy: orderBy,
    );

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  Future<int> updateEvent(Event event) async {
    final db = await dbHelper.database;

    // Update the event
    int result = await db.update('events', event.toMap(), where: 'id = ?', whereArgs: [event.id]);

    // Update associated gifts
    for (Gift gift in event.gifts) {
      if (gift.id == null) {
        // New gift, insert it
        gift.eventId = event.id!;
        await db.insert('gifts', gift.toMap());
      } else {
        // Existing gift, update it
        await db.update('gifts', gift.toMap(), where: 'id = ?', whereArgs: [gift.id]);
      }
    }

    return result;
  }

  Future<int> deleteEvent(int id) async {
    final db = await dbHelper.database;

    // Delete associated gifts first
    await db.delete('gifts', where: 'event_id = ?', whereArgs: [id]);

    // Then delete the event
    return db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, String>>> getEventsForUser(int userId) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> results = await db.query(
      'events',
      columns: ['name', 'category', 'status'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return results.map((event) {
      return {
        "name": event['name'] as String,
        "category": event['category'] as String,
        "status": event['status'] as String,
      };
    }).toList();
  }


}

