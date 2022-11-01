
import 'package:intl/intl.dart';

class PontoTuristico {

  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'name';
  static const CAMPO_DATAINC = 'datainc';
  static const CAMPO_DETALHES = 'detalhes';
  static const CAMPO_DIFERENCIAIS = 'diferenciais';
  static const CAMPO_LATITUDE = 'latitude';
  static const CAMPO_LONGITUDE = 'longitude';
  static const CAMPO_NOMEPONTOMAPA = 'nomepontomapa';

  static const TABELA = 'pontoturistico';

  int? id;
  DateTime datainc = DateTime.now();
  String name = "";
  String? Tabela = "";

  String detalhes = "";
  String diferenciais = "";

  String latitude = "";
  String longitude = "";

  String nomepontomapa = "";

  PontoTuristico(this.id, this.name, this.datainc, this.detalhes, this.diferenciais, this.latitude,this.longitude,this.nomepontomapa);

  Map<String, Object?> toMap() {
    var map = {
      CAMPO_ID: id,
      CAMPO_NOME: name,
      CAMPO_DATAINC: DateFormat("yyyy-MM-dd").format(datainc),
      CAMPO_DETALHES: detalhes,
      CAMPO_DIFERENCIAIS: diferenciais,
      CAMPO_LATITUDE: latitude,
      CAMPO_LONGITUDE: longitude,
      CAMPO_NOMEPONTOMAPA: nomepontomapa,
    };
    return map;
  }

  PontoTuristico.fromDynamic(dynamic map) {
    id = map[CAMPO_ID] is int ? map[CAMPO_ID] : null ;
    name = map[CAMPO_NOME] is String ? map[CAMPO_NOME] : null;
    detalhes = map[CAMPO_DETALHES] is String ? map[CAMPO_DETALHES] : null;
    diferenciais = map[CAMPO_DIFERENCIAIS] is String ? map[CAMPO_DIFERENCIAIS] : null;
    datainc = DateTime.parse(map[CAMPO_DATAINC]);
    latitude = map[CAMPO_LATITUDE] is String ? map[CAMPO_LATITUDE] : null;
    longitude = map[CAMPO_LONGITUDE] is String ? map[CAMPO_LONGITUDE] : null;
    nomepontomapa = map[CAMPO_NOMEPONTOMAPA] is String ? map[CAMPO_NOMEPONTOMAPA] : null;
  }
}