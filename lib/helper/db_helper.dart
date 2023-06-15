import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Student.dart';

class DBHelper {
  static Future<Database>? database;

  static void initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = openDatabase('ECMS_DB',
        onCreate: (db, version) => db.execute(
            "CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)"),
        version: 1);
  }

  static Future<void> insertStudent(Student s) async {
    Database? db = await database;

    if (db != null) {
      await db.insert('students', s.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<Student?> getStudent(String email, String password) async {
    Database? db = await database;

    if (db != null) {
      final List<Map<String, dynamic>> maps = await db.query("students",
          where: "email=? AND password=?", whereArgs: [email, password]);

      if (maps.isEmpty) return null;

      return Student(
          id: maps[0]['id'],
          name: maps[0]['name'],
          email: maps[0]['email'],
          password: maps[0]['password']);
    }

    return null;
  }
}
