import 'package:jhonyproject/Database/db_helper.dart';
import 'package:jhonyproject/Model/ponto_turistico_model.dart';

class PontoTuristicoDao {

  final dbHelper = DBHelper.instance;



  Future<int> salvar(PontoTuristico pontoturistico) async {
    final dbClient = await dbHelper.database;
    final valores = pontoturistico.toMap();
    if(pontoturistico.id == null){
      return await dbClient.insert(PontoTuristico.TABELA, valores);
    } else {
      return update(pontoturistico);
    }
  }

  Future<List<PontoTuristico>> getPontoTuristicos() async {
    var dbClient = await dbHelper.database;
    List<dynamic> maps = await dbClient.query(PontoTuristico.TABELA, columns: ['id', 'name', 'datainc']);
    List<PontoTuristico> pontoturisticos = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        pontoturisticos.add(PontoTuristico.fromDynamic(maps[i]));
      }
    }
    return pontoturisticos;
  }

  Future<int> delete(int id) async {
    var dbClient = await dbHelper.database;
    return await dbClient.delete(
      PontoTuristico.TABELA,
      where: '${PontoTuristico.CAMPO_ID} = ?',
      whereArgs: [id],
    );
  }


  Future<int> update(PontoTuristico pontoturistico) async {
    var dbClient = await dbHelper.database;
    return await dbClient.update(
      PontoTuristico.TABELA,
      pontoturistico.toMap(),
      where: '${PontoTuristico.CAMPO_ID} = ?',
      whereArgs: [pontoturistico.id],
    );
  }

}