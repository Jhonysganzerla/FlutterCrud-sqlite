import 'package:flutter/material.dart';
import 'package:jhonyproject/Pages/filtro_page.dart';
import 'package:jhonyproject/db_helper.dart';
import 'package:jhonyproject/Model/pontoturistico_model.dart';

class PontoTuristicoPage extends StatefulWidget {
  @override
  _PontoTuristicoPageState createState() => _PontoTuristicoPageState();
}

class _PontoTuristicoPageState extends State<PontoTuristicoPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<PontoTuristico>> pontoturisticos = new Future(() => []);
  String _pontoTuristicoName = "";
  bool isUpdate = false;
  int pontoturisticoIdForUpdate = 0;
  DBHelper dbHelper = DBHelper();
  final _pontoTuristicoNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshPontoTuristicoList();
  }

  refreshPontoTuristicoList() {
    setState(() {
      pontoturisticos = dbHelper.getPontoTuristicos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Pontos Turisticos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _abrirPaginaFiltro,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Insira o nome do ponto';
                      }
                      if (value!.trim() == "")
                        return "Somente espaços sõa invalidos!!!";
                      return null;
                    },
                    onSaved: (value) {
                      _pontoTuristicoName = value.toString();
                    },
                    controller: _pontoTuristicoNameController,
                    decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.purple,
                                width: 2,
                                style: BorderStyle.solid)),
                        // hintText: "PontoTuristico Name",
                        labelText: "Nome do Ponto Turistico",
                        icon: Icon(
                          Icons.beach_access,
                          color: Colors.purple,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.purple,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: Text(
                  (isUpdate ? 'Atualizar' : 'Adicionar'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      dbHelper
                          .update(PontoTuristico(pontoturisticoIdForUpdate,
                              _pontoTuristicoName, DateTime.now()))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      dbHelper.add(PontoTuristico(
                          null, _pontoTuristicoName, DateTime.now()));
                    }
                  }
                  _pontoTuristicoNameController.text = '';
                  refreshPontoTuristicoList();
                },
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  (isUpdate ? 'Cancelar Update' : 'Limpar'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _pontoTuristicoNameController.text = '';
                  setState(() {
                    isUpdate = false;
                    pontoturisticoIdForUpdate = 0;
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: pontoturisticos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList((snapshot.data));
                }
                if (snapshot.data == null || snapshot.data!.length == 0) {
                  return Text('Nada encontrado');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<PontoTuristico>? pontoturisticos) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Nome',
                  style: new TextStyle(
                      fontSize: 11.0, overflow: TextOverflow.ellipsis),
                ),
              ),
              DataColumn(
                label: Text(
                  'Data Criação',
                  style: new TextStyle(
                      fontSize: 11.0, overflow: TextOverflow.ellipsis),
                ),
              ),
              DataColumn(
                label: Text(
                  'Deletar',
                  style: new TextStyle(
                      fontSize: 11.0, overflow: TextOverflow.ellipsis),
                ),
              )
            ],
            rows: pontoturisticos!
                .map(
                  (pontoturistico) => DataRow(
                    cells: [
                      DataCell(
                        Container(
                            child: Text(
                          overflow: TextOverflow.ellipsis,
                          pontoturistico.name,
                          style: new TextStyle(
                              fontSize: 11.0, overflow: TextOverflow.ellipsis),
                        )),
                        onTap: () {
                          setState(() {
                            isUpdate = true;
                            pontoturisticoIdForUpdate = pontoturistico.id!;
                          });
                          _pontoTuristicoNameController.text =
                              pontoturistico.name;
                        },
                      ),
                      DataCell(
                        Text(
                          "${pontoturistico.datainc.day}/${pontoturistico.datainc.month}/${pontoturistico.datainc.year}",
                          style: new TextStyle(
                              fontSize: 9.0, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          iconSize: 15,
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            dbHelper.delete(pontoturistico.id!);
                            refreshPontoTuristicoList();
                          },
                        ),
                      )
                    ],
                  ),
                )
                .toList(),
          )),
    );
  }

  void _abrirPaginaFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores) {
      if (alterouValores == true) {}
    });
  }
}
