import 'package:flutter/material.dart';
import 'package:jhonyproject/Dao/ponto_turistico_dao.dart';
import 'package:jhonyproject/Pages/filtro_page.dart';
import 'package:jhonyproject/Model/ponto_turistico_model.dart';
import 'package:jhonyproject/Pages/gps_page.dart';
import 'package:jhonyproject/Pages/ponto_turistico_detalhes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PontoTuristicoPage extends StatefulWidget {
  @override
  _PontoTuristicoPageState createState() => _PontoTuristicoPageState();
}

class _PontoTuristicoPageState extends State<PontoTuristicoPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<PontoTuristico>> pontoturisticos = new Future(() => []);
  String _pontoTuristicoName = "";
  String _pontoTuristicoDetalhes = "";
  String _pontoTuristicoDiferenciais = "";
  String _pontoTuristicoLatitude = "";
  String _pontoTuristicoLongitude = "";
  String _pontoTuristicoNomePontoMapa = "";
  String _pontoTuristicoCep = "";
  String _pontoTuristicoLogradouro = "";
  String _pontoTuristicoBairro = "";
  int pontoturisticoIdForUpdate = 0;



  bool isUpdate = false;
  PontoTuristicoDao pontoTuristicoDao = PontoTuristicoDao();
  final _pontoTuristicoNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pontoTuristicoDao = PontoTuristicoDao();
    refreshPontoTuristicoList();
  }

  refreshPontoTuristicoList() async {
    final prefs = await SharedPreferences.getInstance();
    final campoordenacao = prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? PontoTuristico.CAMPO_ID;
    final usarOrdemDecrescente = prefs.getBool(FiltroPage.chaveOrdenacaoDrescente) == true;
    final filtrodescricao = prefs.getString(FiltroPage.chaveFiltroNome) ?? "";
    setState(() {
      pontoturisticos = pontoTuristicoDao.getPontoTuristicos(
            filtro: filtrodescricao,
            campoOrdenacao: campoordenacao,
            usarOrdemDecrescente: usarOrdemDecrescente,
          );
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
          ),
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
                      pontoTuristicoDao
                          .salvar(PontoTuristico(
                          pontoturisticoIdForUpdate,
                          _pontoTuristicoName,
                          DateTime.now(),
                          _pontoTuristicoDetalhes,
                          _pontoTuristicoDiferenciais,
                          _pontoTuristicoLatitude,
                          _pontoTuristicoLongitude,
                          _pontoTuristicoNomePontoMapa,
                          _pontoTuristicoCep,
                          _pontoTuristicoLogradouro,
                          _pontoTuristicoBairro))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                          _pontoTuristicoNameController.text = '';
                          _pontoTuristicoDetalhes = '';
                          _pontoTuristicoDiferenciais = '';
                          _pontoTuristicoLatitude = '';
                          _pontoTuristicoLongitude = '';
                          _pontoTuristicoNomePontoMapa = '';
                          _pontoTuristicoCep = '';
                          _pontoTuristicoLogradouro = '';
                          _pontoTuristicoBairro = '';
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      pontoTuristicoDao.salvar(PontoTuristico(
                          null,
                          _pontoTuristicoName,
                          DateTime.now(),
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          "",
                          ""));
                    }
                  }
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
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Visibility(
                visible: isUpdate,
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    'Detalhar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    PontoTuristico pontoturistico = PontoTuristico(
                        pontoturisticoIdForUpdate,
                        _pontoTuristicoName,
                        DateTime.now(),
                        _pontoTuristicoDetalhes ?? "",
                        _pontoTuristicoDiferenciais ?? "",
                        _pontoTuristicoLatitude ?? "",
                        _pontoTuristicoLongitude ?? "",
                        _pontoTuristicoNomePontoMapa ?? "",
                        _pontoTuristicoCep    ?? "",
                        _pontoTuristicoLogradouro ?? "",
                        _pontoTuristicoBairro ?? "");

                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>
                            PontoTuristicoDetalhePage(
                                pontoturistico: pontoturistico,
                                pontoTuristicoDao: pontoTuristicoDao)
                        )
                    ).whenComplete(() =>
                      refreshPontoTuristicoList(),
                    );
                   isUpdate = false;
                  },
                )
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
                            _pontoTuristicoDiferenciais = pontoturistico.diferenciais;
                            _pontoTuristicoDetalhes = pontoturistico.detalhes;
                            _pontoTuristicoLatitude = pontoturistico.latitude;
                            _pontoTuristicoLongitude = pontoturistico.longitude;
                            _pontoTuristicoNomePontoMapa = pontoturistico.nomepontomapa;
                            _pontoTuristicoCep = pontoturistico.cep;
                            _pontoTuristicoLogradouro  = pontoturistico.logradouro;
                            _pontoTuristicoBairro  = pontoturistico.bairro;
                          });
                          _pontoTuristicoNameController.text = pontoturistico.name;
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
                            pontoTuristicoDao.delete(pontoturistico.id!);
                            refreshPontoTuristicoList();
                          },
                        ),
                      ),
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
      if (alterouValores == true) {
          refreshPontoTuristicoList();
      }
    });
  }

}
