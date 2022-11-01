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

  Future<List<PontoTuristico>> getPontoTuristicos(
      {
        String filtro = '',
        String campoOrdenacao = PontoTuristico.CAMPO_ID,
        bool usarOrdemDecrescente = false
      }) async {
    var dbClient = await dbHelper.database;
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${PontoTuristico.CAMPO_NOME}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }

    List<dynamic> maps = await dbClient.query
      (PontoTuristico.TABELA,
        columns: [
          PontoTuristico.CAMPO_ID,
          PontoTuristico.CAMPO_NOME,
          PontoTuristico.CAMPO_DATAINC,
          PontoTuristico.CAMPO_DETALHES,
          PontoTuristico.CAMPO_DIFERENCIAIS,
          PontoTuristico.CAMPO_LATITUDE,
          PontoTuristico.CAMPO_LONGITUDE,
          PontoTuristico.CAMPO_NOMEPONTOMAPA,
          ],
        where: where,
        orderBy: orderBy,
    );
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