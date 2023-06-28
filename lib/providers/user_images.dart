import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:grada_app/models/picture.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'images.db'),
      onCreate: (db, version) {
    return db
        .execute('CREATE TABLE user_images(id TEXT PRIMARY KEY, image TEXT)');
  }, version: 1);
  return db;
}

class UserImagesNotifier extends StateNotifier<List<Picture>> {
  UserImagesNotifier() : super(const []);

  Future<void> loadImages() async {
    final db = await _getDatabase();
    final data = await db.query('user_images');
    final images = data.map(
        (row) => Picture(id: row['id'] as String, image: File(row['image'] as String))).toList();
        state = images;
  }
  

  void addImage(File image) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newIamge = Picture(image: copiedImage);

    final db = await _getDatabase();
    db.insert('user_images', {
      "id": newIamge.id,
      "image": newIamge.image.path,
    });

    state = [...state, newIamge];
    await loadImages(); 
    
  }

    Future<void> deleteImage(Picture picture) async {
    final db = await _getDatabase();
    await db.delete(
      'user_images',
      where: 'id = ?',
      whereArgs: [picture.id],
    );

    
    state = state.where((p) => p.id != picture.id).toList();
    await loadImages();
  }


}

final userImagesProvider =
    StateNotifierProvider<UserImagesNotifier, List<Picture>>(
        (ref) => UserImagesNotifier());
