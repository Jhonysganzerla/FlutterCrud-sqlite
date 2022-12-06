import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhonyproject/Dao/ponto_turistico_dao.dart';
import 'package:jhonyproject/Model/ponto_turistico_model.dart';
import 'package:jhonyproject/Pages/gps_page.dart';

class PontoTuristicoDetalhePage extends StatefulWidget{
  static const ROUTE_NAME = '/detalhes';
  final PontoTuristico pontoturistico;
  final PontoTuristicoDao pontoTuristicoDao;

  const PontoTuristicoDetalhePage({Key? key,
    required this.pontoturistico,
    required this.pontoTuristicoDao }) : super(key: key);

  _PontoTuristicoDetalhePageState createState() => _PontoTuristicoDetalhePageState();

}

class _PontoTuristicoDetalhePageState extends State<PontoTuristicoDetalhePage>{
  final _diferenciaisController = TextEditingController();
  final _detalhesController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _nomePontoMapaController = TextEditingController();


  @override
  Widget build(BuildContext context){
    preencheController();

    return
      WillPopScope(
        onWillPop: _onVoltarClick,
        child:
       Scaffold(
          appBar: AppBar(
            title: Text('Detalhes do Ponto'),
          ),
          body: _criarBody(),
       )
      );
  }

  Future<bool> _onVoltarClick() async {
    widget.pontoturistico.diferenciais = _diferenciaisController.text;
    widget.pontoturistico.detalhes = _detalhesController.text;
    widget.pontoturistico.latitude = _latitudeController.text;
    widget.pontoturistico.longitude = _longitudeController.text;
    widget.pontoturistico.nomepontomapa = _nomePontoMapaController.text;

    await widget.pontoTuristicoDao.update(widget.pontoturistico);

    Navigator.of(context).pop();

    return true;
  }

  preencheController(){
    _diferenciaisController.text = widget.pontoturistico.diferenciais;
    _detalhesController.text = widget.pontoturistico.detalhes;
    _latitudeController.text = widget.pontoturistico.latitude;
    _longitudeController.text = widget.pontoturistico.longitude;
    _nomePontoMapaController.text = widget.pontoturistico.nomepontomapa;

  }

  void _abrirPaginaGPS() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) =>
            GpsPage(
                pontoturistico: widget.pontoturistico)
        )
    ).then((value) => preencheMapas(value));
  }

  preencheMapas(value){
    widget.pontoturistico.latitude = value.latitude;
    widget.pontoturistico.longitude = value.longitude;
    widget.pontoturistico.nomepontomapa = value.nomepontomapa;
  }

  Widget _criarBody() =>
      ListView(
          children: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: _abrirPaginaGPS,
            ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child:
                TextField(
                  controller: _detalhesController,
                  decoration: const InputDecoration(
                  labelText: 'Adicione os detalhes aqui',
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child:
                    TextField(
                    decoration: const InputDecoration(
                      labelText: 'Adicione os diferenciais aqui',
                    ),
                    controller: _diferenciaisController,
                  ),
                )
            ],
          ),
        ],
    );
}