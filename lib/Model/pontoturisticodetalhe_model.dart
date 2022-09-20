import 'package:jhonyproject/Model/pontoturistico_model.dart';

class PontoTuristicoDetalhe {
  int? id;
  PontoTuristico? pontoTuristico;
  String descricao = "";
  String diferenciais = "";

  PontoTuristicoDetalhe(this.id, this.pontoTuristico, this.descricao, this.diferenciais);

  Map<String, Object?> toMap() {
    var map = {
      'id': id,
      'pontoTuristico': pontoTuristico,
      'descricao': descricao,
      'diferenciais': diferenciais,
    };
    return map;
  }

  PontoTuristicoDetalhe.fromDynamic(dynamic map) {
    id = map['id'];
    pontoTuristico = map['name'];
    descricao = map['descricao'];
    diferenciais = map['diferenciais'];
  }
}