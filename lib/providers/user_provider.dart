import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../models/user.dart';

// Future<Database> _getDatabase() async {
//   final dbPath = await sql.getDatabasesPath();

//   final db = path.join(path.join(dbPath) 'users.db')
//   final db = await sql.openDatabase(dbPath, onCreate: (db, version) {
//     return db.execute('CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, surname TEXT, email TEXT, password TEXT)');
//   }, version: 1);
//   return db;
// }

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'users.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, surname TEXT, email TEXT, password TEXT)');
  }, version: 1);
  return db;
}

class UserStateNotifier extends StateNotifier<List<AppUser>> {
  UserStateNotifier() : super([]);

  Future<void> loadUsers() async {
    final db = await _getDatabase();
    final data = await db.query('users');
    final users = data
        .map((row) => AppUser(
              id: row['id'] as String,
              name: row['name'] as String,
              surname: row['surname'] as String,
              email: row['email'] as String,
              password: row['password'] as String,
            ))
        .toList();
    state = users;
  }

  Future<void> addUser(AppUser user) async {
    // final appDir = await syspaths.getApplicationDocumentsDirectory();

    final newUser = AppUser(
      id: user.id,
      name: user.name,
      surname: user.surname,
      password: user.password,
      email: user.email,
    );

    final db = await _getDatabase();
    await db.insert(
      'users',
      {
        'id': newUser.id,
        'name': newUser.name,
        'surname': newUser.surname,
        'email': newUser.email,
        'password': newUser.password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    state = [...state, newUser];
    await loadUsers();
  }

  Future<void> deleteUser(AppUser user) async {
    final db = await _getDatabase();
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [user.id],
    );
    state = state.where((u) => u.id != user.id).toList();
  }
}

final userProvider = StateNotifierProvider<UserStateNotifier, List<AppUser>>(
  (ref) => UserStateNotifier(),
);
