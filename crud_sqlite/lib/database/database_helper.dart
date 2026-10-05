import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Configuração para rodar no Navegador (Web)
    if (kIsWeb) {
      var databaseFactory = databaseFactoryFfiWeb;
      return await databaseFactory.openDatabase(
        'users.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) {
            return db.execute(
              'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)',
            );
          },
        ),
      );
    }

    // Configuração para rodar no Android / iOS / Desktop
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT)',
        );
      },
    );
  }

  // CREATE
  Future<int> insertUser(UserModel user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  // READ
  Future<List<UserModel>> getUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  // UPDATE
  Future<int> updateUser(UserModel user) async {
    Database db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // DELETE
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}