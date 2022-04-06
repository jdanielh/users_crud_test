import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import '../models/user.dart';

class DBProvider {
  // static Future<Database>? _database;


  Future<Database> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'users_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sex INTEGER, birthday DATETIME)',
        );
      },
      version: 1,
    );
  }


  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final Database db = await initDB();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> users() async {
    // Get a reference to the database.
    final Database db = await initDB();

    // Query the table for all The users.
    final List<Map<String, dynamic>> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        sex: maps[i]['sex'],
        dateOfBirth: maps[i]['birthday'],
      );
    });
  }


  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final Database db = await initDB();

    // Update the given User.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the user has a matching id.
      where: 'id = ?',
      // Pass the user's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int? id) async {
    // Get a reference to the database.
    final Database db = await initDB();

    // Remove the User from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific user.
      where: 'id = ?',
      // Pass the user's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }



}