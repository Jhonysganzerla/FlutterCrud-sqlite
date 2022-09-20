import 'package:jhonyproject/Model/pontoturistico_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {

  static Database? _db;
  Future<Database> get database async =>
      _db ??= await initDatabase();


  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'pontoturistico.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE pontoturistico (id INTEGER PRIMARY KEY, name TEXT, datainc DATE)');
  }

  Future<PontoTuristico> add(PontoTuristico pontoturistico) async {
    var dbClient = await database;
    pontoturistico.id = await dbClient.insert('pontoturistico', pontoturistico.toMap());
    return pontoturistico;
  }

  Future<List<PontoTuristico>> getPontoTuristicos() async {
    var dbClient = await database;
    List<dynamic> maps = await dbClient.query('pontoturistico', columns: ['id', 'name', 'datainc']);
    List<PontoTuristico> pontoturisticos = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
          pontoturisticos.add(PontoTuristico.fromDynamic(maps[i]));
      }
    }
    return pontoturisticos;
  }

  Future<int> delete(int id) async {
    var dbClient = await database;
    return await dbClient.delete(
      'pontoturistico',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(PontoTuristico pontoturistico) async {
    var dbClient = await database;
    return await dbClient.update(
      'pontoturistico',
      pontoturistico.toMap(),
      where: 'id = ?',
      whereArgs: [pontoturistico.id],
    );
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}
