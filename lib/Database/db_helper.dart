import 'package:jhonyproject/Model/ponto_turistico_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {

  static Database? _db;
  static const _dbVersion = 1;

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database> get database async =>
      _db ??= await initDatabase();


  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'pontoturistico.db');
    var db = await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('''
        CREATE TABLE ${PontoTuristico.TABELA}(
        ${PontoTuristico.CAMPO_ID} INTEGER PRIMARY KEY,
        ${PontoTuristico.CAMPO_NOME} TEXT,
        ${PontoTuristico.CAMPO_DATAINC} DATE,
        ${PontoTuristico.CAMPO_DETALHES} TEXT,
        ${PontoTuristico.CAMPO_DIFERENCIAIS} TEXT)
        ''');
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {


  }


  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}
