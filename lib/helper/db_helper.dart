import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Booking.dart';
import '../model/Classroom.dart';
import '../model/Provider.dart';

class DBHelper {
  static Future<Database>? database;

  static void initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = openDatabase('ECMS_DB',
        onCreate: onDatabaseCreated, onUpgrade: onDatabaseUpgrade, version: 1);
  }

  static FutureOr<void> onDatabaseUpgrade(
      Database db, int oldVersion, int newVersion) {
    db.execute("DROP TABLE IF EXISTS providers");
    db.execute("DROP TABLE IF EXISTS classroom");
    db.execute("DROP TABLE IF EXISTS booking");

    onDatabaseCreated(db, newVersion);
  }

  static FutureOr<void> onDatabaseCreated(Database db, int version) {
    db.execute(
        "CREATE TABLE providers(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)");
    db.execute(
        "CREATE TABLE classroom(id INTEGER PRIMARY KEY, name TEXT, email TEXT, maxStudent INTEGER)");
    db.execute(
        "CREATE TABLE booking(id INTEGER PRIMARY KEY,classroomId INTEGER, providerId INTEGER, sessionStartTime DATETIME, sessionEndTime DATETIME, numStudent INTEGER, attendedStudent INTEGER, FOREIGN KEY(classroomId) REFERENCES classroom(id) FOREIGN KEY(providerId) REFERENCES providers(id));");

    db.insert(
        "classroom", Classroom(id: 0, name: "Room1", maxStudent: 30).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    db.insert(
        "classroom", Classroom(id: 0, name: "Room2", maxStudent: 30).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    db.insert(
        "classroom", Classroom(id: 0, name: "Room3", maxStudent: 30).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertProvider(Provider s) async {
    Database? db = await database;

    if (db != null) {
      await db.insert('providers', s.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<Provider?> getProvider(String email, String password) async {
    Database? db = await database;

    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query("providers",
          where: "email=? AND password=?", whereArgs: [email, password]);

      if (maps.isEmpty) return null;

      return Provider(
          id: maps[0]['id'],
          name: maps[0]['name'],
          email: maps[0]['email'],
          password: maps[0]['password']);
    }

    return null;
  }
}
