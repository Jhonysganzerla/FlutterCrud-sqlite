
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
  static const CAMPO_CEP = 'cep';
  static const CAMPO_LOGRADOURO = 'logradouro';
  static const CAMPO_BAIRRO = 'bairro';

  static const TABELA = 'pontoturistico';

  String? Tabela = "";

  int? id;
  DateTime datainc = DateTime.now();
  String name = "";
  String detalhes = "";
  String diferenciais = "";
  String latitude = "";
  String longitude = "";
  String nomepontomapa = "";
  String cep = "";
  String logradouro = "";
  String bairro = "";

  PontoTuristico(this.id,
      this.name,
      this.datainc,
      this.detalhes,
      this.diferenciais,
      this.latitude,
      this.longitude,
      this.nomepontomapa,
      this.cep,
      this.logradouro,
      this.bairro);

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
      CAMPO_CEP: cep,
      CAMPO_LOGRADOURO: logradouro,
      CAMPO_BAIRRO: bairro,
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

    cep = map[CAMPO_CEP] is String ? map[CAMPO_CEP] : null;
    logradouro = map[CAMPO_LOGRADOURO] is String ? map[CAMPO_LOGRADOURO] : null;
    bairro = map[CAMPO_BAIRRO] is String ? map[CAMPO_BAIRRO] : null;
  }
}