
import 'package:intl/intl.dart';

class PontoTuristico {

  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'name';
  static const CAMPO_DATAINC = 'datainc';
  static const CAMPO_DETALHES = 'detalhes';
  static const CAMPO_DIFERENCIAIS = 'diferenciais';

  static const TABELA = 'pontoturistico';

  int? id;
  DateTime datainc = DateTime.now();
  String name = "";
  String? Tabela = "";

  String detalhes = "";
  String diferenciais = "";


  PontoTuristico(this.id, this.name, this.datainc, this.detalhes, this.diferenciais);

  Map<String, Object?> toMap() {
    var map = {
      CAMPO_ID: id,
      CAMPO_NOME: name,
      CAMPO_DATAINC: DateFormat("yyyy-MM-dd").format(datainc),
      CAMPO_DETALHES: detalhes,
      CAMPO_DIFERENCIAIS: diferenciais,
    };
    return map;
  }

  PontoTuristico.fromDynamic(dynamic map) {
    id = map[CAMPO_ID] is int ? map[CAMPO_ID] : null ;
    name = map[CAMPO_NOME] is String ? map[CAMPO_NOME] : null;
    detalhes = map[CAMPO_DETALHES] is String ? map[CAMPO_DETALHES] : null;
    diferenciais = map[CAMPO_DIFERENCIAIS] is String ? map[CAMPO_DIFERENCIAIS] : null;
    datainc = DateTime.parse(map[CAMPO_DATAINC]);
  }
}