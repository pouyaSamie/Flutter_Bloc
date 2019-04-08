import 'dart:io';

import 'package:hello_bloc/src/models/favorite_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "WatchList.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE FavoriteMovies ("
          "id INTEGER PRIMARY KEY,"
          "movie_title TEXT,"
          "poster_path TEXT,"
          "movie_id INTEGER"
          ")");
    });
  }

  Future<int> addToFavorite(FavoriteMovie favoriteMovie) async {
    print("add");
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM FavoriteMovies");
    int id = table.first["id"];
    print(id);
    return db.rawInsert(
        "INSERT Into FavoriteMovies (id,movie_title,poster_path,movie_id)"
        " VALUES (?,?,?,?)",
        [id, favoriteMovie.title, favoriteMovie.posterUrl, favoriteMovie.id]);
  }

  Future<int> deleteFavorite(int id) async {
    final db = await database;

    var res = await db
        .delete("FavoriteMovies", where: 'movie_id = ?', whereArgs: [id]);

    print("delete:$res");
    return res;
  }

  Future<FavoriteMovie> getFavoriteMovie(int id) async {
    final db = await database;
    var res = await db
        .query("FavoriteMovies", where: "movie_id = ?", whereArgs: [id]);

    return res.isNotEmpty
        ? FavoriteMovie.fromJson(res.first)
        : Future<FavoriteMovie>.value(null);
  }

  Future<bool> isFavorite(int id) async {
    final db = await database;
    var res = await db
        .query("FavoriteMovies", where: "movie_id = ?", whereArgs: [id]);

    return res.isNotEmpty;
  }

  Future<List<FavoriteMovie>> getFavoriteList() async {
    final db = await database;
    var res = await db.query("FavoriteMovies");
    List<FavoriteMovie> list = res.isNotEmpty
        ? res.map((c) => FavoriteMovie.fromJson(c)).toList()
        : [];
    return list;
  }
}
