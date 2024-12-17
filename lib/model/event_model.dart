import 'package:sqflite/sqflite.dart';

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



  Future<void> addEvent(Map<String, dynamic> newEvent, int userId) async {
    final db = await dbHelper.database;

    await db.insert(
      'events',
      {
        'name': newEvent['name'],
        'date': newEvent['date'],
        'category': newEvent['category'],
        'status': newEvent['status'],
        'location': newEvent['location'],
        'description': newEvent['description'],
        'user_id': userId, // Ensure userId is passed when calling the function
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle duplicates if needed
    );
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

  Future<int> updateEvent(int eventId, Map<String, dynamic> updatedEvent) async {
    final db = await dbHelper.database;

    final String name = updatedEvent['name'];
    final String category = updatedEvent['category'];
    final String status = updatedEvent['status'];
    final String location = updatedEvent['location'];
    final String description = updatedEvent['description'];
    final String date = updatedEvent['date'];

    final Map<String, dynamic> updateData = {
      'name': name,
      'category': category,
      'status': status,
      'location': location,
      'description': description,
      'date': date,
    };

    int result = await db.update(
      'events',
      updateData,
      where: 'id = ?',
      whereArgs: [eventId],
    );

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

  Future<List<Map<String, dynamic>>> getEventsWithGifts(int userId) async {
    final db = await dbHelper.database;

    // Query to fetch events for the user, including location, date, and description
    const eventsQuery = '''
  SELECT 
    e.id AS eventId,
    e.name AS eventName,
    e.category AS eventCategory,
    e.status AS eventStatus,
    e.location AS eventLocation,
    e.date AS eventDate,
    e.description AS eventDescription
  FROM events e
  WHERE e.user_id = ?
  ''';

    const giftsQuery = '''
  SELECT 
    g.name AS giftName,
    g.category AS giftCategory,
    g.pledged AS giftPledged,
    g.event_id AS eventId
  FROM gifts g
  ''';

    // Fetch events
    final eventResults = await db.rawQuery(eventsQuery, [userId]);
    final giftResults = await db.rawQuery(giftsQuery);

    // Organize events and their associated gifts
    final Map<int, List<Map<String, dynamic>>> eventGifts = {};
    for (final gift in giftResults) {
      final eventId = gift['eventId'] as int;
      eventGifts.putIfAbsent(eventId, () => []).add({
        'name': gift['giftName'],
        'category': gift['giftCategory'],
        'status': (gift['giftPledged'] == 1) ? 'Pledged' : 'not Pledged',
      });
    }

    // Combine event data with their associated gifts
    final List<Map<String, dynamic>> events = eventResults.map((event) {
      final eventId = event['eventId'] as int;
      return {
        'id': eventId, // Add the event ID here
        'name': event['eventName'],
        'category': event['eventCategory'],
        'status': event['eventStatus'],
        'location': event['eventLocation'],
        'date': event['eventDate'],
        'description': event['eventDescription'],
        'gifts': eventGifts[eventId] ?? [],
      };
    }).toList();

    return events;
  }

  Future<int> getUserIdByEventId(int eventId) async {
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'events',
      columns: ['user_id'],
      where: 'id = ?',
      whereArgs: [eventId],
      limit: 1,
    );

    return result.first['user_id'] as int;

  }


  Future<String> getEventDateById(int eventId) async {
    final db = await dbHelper.database;
    // Query the database to fetch the date of the event with the given ID
    final List<Map<String, dynamic>> result = await db.query(
      'events',
      columns: ['date'], // Fetch only the date column
      where: 'id = ?',
      whereArgs: [eventId],
    );

      // Return the event date as a string
    return result.first['date'] as String;


  }


}

