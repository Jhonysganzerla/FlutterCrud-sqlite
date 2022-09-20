class PontoTuristico {

  static const CAMPO_ID = '_id';
  static const CAMPO_NOME = 'Nome';
  static const CAMPO_DATAINC = 'Data';

  int? id;
  DateTime datainc = DateTime.now();
  String name = "";

  PontoTuristico(this.id, this.name, this.datainc);

  Map<String, Object?> toMap() {
    var map = {
      'id': id,
      'name': name,
      'datainc': datainc.toString(),
    };
    return map;
  }

  PontoTuristico.fromDynamic(dynamic map) {
    id = map['id'];
    name = map['name'];
    datainc = DateTime.parse(map['datainc']);
  }
}