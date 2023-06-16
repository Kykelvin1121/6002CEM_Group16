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
        onCreate: onDatabaseCreated, onUpgrade: onDatabaseUpgrade, version: 6);
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
        "CREATE TABLE providers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT)");
    db.execute(
        "CREATE TABLE classroom(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, maxStudent INTEGER)");
    db.execute(
        "CREATE TABLE booking(id INTEGER PRIMARY KEY AUTOINCREMENT,classroomId INTEGER, providerId INTEGER, sessionStartTime DATETIME, sessionEndTime DATETIME, numStudent INTEGER, attendedStudent INTEGER, FOREIGN KEY(classroomId) REFERENCES classroom(id) FOREIGN KEY(providerId) REFERENCES providers(id));");

    db.insert(
        "classroom", Classroom(id: 0, name: "Room1", maxStudent: 30).toMap());
    db.insert(
        "classroom", Classroom(id: 0, name: "Room2", maxStudent: 30).toMap());
    db.insert(
        "classroom", Classroom(id: 0, name: "Room3", maxStudent: 30).toMap());
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

    if (db == null) return null;

    final List<Map<String, dynamic>> maps = await db.query("providers",
        where: "email=? AND password=?", whereArgs: [email, password]);

    if (maps.isEmpty) return null;

    return Provider(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password']);
  }

  static Future<Classroom?> getClassroom(int id) async {
    Database? db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> maps =
        await db.query("classroom", where: "id=?", whereArgs: [id]);

    if (maps.isEmpty) return null;

    return Classroom(
      id: maps[0]['id'],
      name: maps[0]['name'],
      maxStudent: maps[0]['maxStudent'],
    );
  }

  static Future<int> insertBooking(Booking b) async {
    Database? db = await database;

    int valid = await checkBookingValidity(b);

    if (db != null && valid == 0) {
      await db.insert('booking', b.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return valid;
  }

  static Future<List<Classroom>?> getAllClassroom() async {
    Database? db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> maps = await db.query("classroom");

    if (maps.isEmpty) return null;

    return List.generate(maps.length, (i) {
      return Classroom(
        id: maps[i]['id'],
        name: maps[i]['name'],
        maxStudent: maps[i]['maxStudent'],
      );
    });
  }

  static Future<bool> updateBookingAttendance(
      int bookingId, int attended) async {
    Database? db = await database;

    bool valid = await checkBookingAttendanceValidity(bookingId, attended);

    if (db != null && valid) {
      await db.update(
        'booking',
        {"attendedStudent": attended},
        // Ensure that the Dog has a matching id.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [bookingId],
      );
    }
    return valid;
  }

  static Future<bool> checkBookingAttendanceValidity(
      int bookingId, int attended) async {
    Database? db = await database;

    if (db == null) return false;

    final List<Map<String, dynamic>> maps =
        await db.query("booking", where: "id=?", whereArgs: [bookingId]);

    if (maps.isEmpty) return false;

    Booking b = Booking(
      id: maps[0]['id'],
      classroomId: maps[0]['classroomId'],
      providerId: maps[0]['providerId'],
      sessionStartTime: DateTime.parse(maps[0]['sessionStartTime']),
      sessionEndTime: DateTime.parse(maps[0]['sessionEndTime']),
      numStudent: maps[0]['numStudent'],
      attendedStudent: maps[0]['attendedStudent'],
    );

    if (attended > b.numStudent) {
      return false;
    }

    return true;
  }

  static Future<List<Booking>?> getBookingListFromClassroom(Booking b) async {
    Database? db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> maps = await db
        .query("booking", where: "classroomId=?", whereArgs: [b.classroomId]);

    if (maps.isEmpty) return null;

    return List.generate(maps.length, (i) {
      return Booking(
        id: maps[i]['id'],
        classroomId: maps[i]['classroomId'],
        providerId: maps[i]['providerId'],
        sessionStartTime: DateTime.parse(maps[i]['sessionStartTime']),
        sessionEndTime: DateTime.parse(maps[i]['sessionEndTime']),
        numStudent: maps[i]['numStudent'],
        attendedStudent: maps[i]['attendedStudent'],
      );
    });
  }

  static Future<List<Booking>?> getBookingListFromProvider(Provider p) async {
    Database? db = await database;

    if (db == null) return null;

    final List<Map<String, dynamic>> maps =
        await db.query("booking", where: "providerId=?", whereArgs: [p.id]);

    if (maps.isEmpty) return null;

    return List.generate(maps.length, (i) {
      return Booking(
        id: maps[i]['id'],
        classroomId: maps[i]['classroomId'],
        providerId: maps[i]['providerId'],
        sessionStartTime: DateTime.parse(maps[i]['sessionStartTime']),
        sessionEndTime: DateTime.parse(maps[i]['sessionEndTime']),
        numStudent: maps[i]['numStudent'],
        attendedStudent: maps[i]['attendedStudent'],
      );
    });
  }

  static Future<int> checkBookingValidity(Booking b) async {
    Database? db = await database;
    int result = 0;

    if (db == null) {
      result = 1;
    }

    //check if classroom valid
    if (result == 0) {
      Classroom? c = await getClassroom(b.classroomId);
      if (c == null) {
        result = 2;
      } else if (c.maxStudent < b.numStudent) {
        result = 3;
      }
    }

    //check if classroom being booked
    if (result == 0) {
      List<Booking>? bookingList = await getBookingListFromClassroom(b);
      if (bookingList != null && bookingList.isNotEmpty) {
        for (var booking in bookingList) {
          if ((b.sessionStartTime.isAfter(booking.sessionStartTime) &&
                  b.sessionStartTime.isBefore(booking.sessionEndTime)) ||
              (b.sessionEndTime.isAfter(booking.sessionStartTime) &&
                  b.sessionEndTime.isBefore(booking.sessionEndTime))) {
            result = 4;
          }
        }
      }
    }

    if (result == 0) {
      if (b.sessionEndTime.isBefore(b.sessionStartTime)) {
        result = 5;
      }
    }
    return result;
  }
}
