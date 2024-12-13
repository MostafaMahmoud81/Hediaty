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

}

