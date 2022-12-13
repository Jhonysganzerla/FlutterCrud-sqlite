import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jhonyproject/Dao/ponto_turistico_dao.dart';
import 'package:jhonyproject/Model/cep.dart';
import 'package:jhonyproject/Model/ponto_turistico_model.dart';
import 'package:jhonyproject/Pages/gps_page.dart';
import 'package:jhonyproject/Services/cep_services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PontoTuristicoDetalhePage extends StatefulWidget {
  static const ROUTE_NAME = '/detalhes';
  final PontoTuristico pontoturistico;
  final PontoTuristicoDao pontoTuristicoDao;

  const PontoTuristicoDetalhePage(
      {Key? key, required this.pontoturistico, required this.pontoTuristicoDao})
      : super(key: key);

  _PontoTuristicoDetalhePageState createState() =>
      _PontoTuristicoDetalhePageState();
}

class _PontoTuristicoDetalhePageState extends State<PontoTuristicoDetalhePage> {
  final _diferenciaisController = TextEditingController();
  final _detalhesController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _nomePontoMapaController = TextEditingController();
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _bairroController = TextEditingController();
  CepService cepService = CepService();
  bool _loading = false;

  final _cepFormatter = MaskTextInputFormatter(
      mask: '#####-###', filter: {'#': RegExp(r'[0-9]')});
  Cep? _cep;

  @override
  Widget build(BuildContext context) {
    preencheController();

    return WillPopScope(
        onWillPop: _onVoltarClick,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Detalhes do Ponto'),
          ),
          body: _criarBody(),
        ));
  }

  Future<bool> _onVoltarClick() async {
    widget.pontoturistico.diferenciais = _diferenciaisController.text;
    widget.pontoturistico.detalhes = _detalhesController.text;
    widget.pontoturistico.latitude = _latitudeController.text;
    widget.pontoturistico.longitude = _longitudeController.text;
    widget.pontoturistico.nomepontomapa = _nomePontoMapaController.text;
    widget.pontoturistico.cep = _cepController.text;
    widget.pontoturistico.bairro = _bairroController.text;
    widget.pontoturistico.logradouro = _logradouroController.text;


    await widget.pontoTuristicoDao.update(widget.pontoturistico);

    Navigator.of(context).pop();

    return true;
  }

  preencheController() {
    _diferenciaisController.text = widget.pontoturistico.diferenciais;
    _detalhesController.text = widget.pontoturistico.detalhes;
    _latitudeController.text = widget.pontoturistico.latitude;
    _longitudeController.text = widget.pontoturistico.longitude;
    _nomePontoMapaController.text = widget.pontoturistico.nomepontomapa;
    _cepController.text = widget.pontoturistico.cep;
    _logradouroController.text = widget.pontoturistico.logradouro;
    _bairroController.text = widget.pontoturistico.bairro;
  }

  void _abrirPaginaGPS() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => GpsPage(pontoturistico: widget.pontoturistico)))
        .then((value) => preencheMapas(value));
  }

  preencheMapas(value) {
    widget.pontoturistico.latitude = value.latitude;
    widget.pontoturistico.longitude = value.longitude;
    widget.pontoturistico.nomepontomapa = value.nomepontomapa;
    widget.pontoturistico.cep = value.cep;
    widget.pontoturistico.logradouro = value.logradouro;
    widget.pontoturistico.bairro = value.bairro;
  }

  Widget _criarBody() => ListView(
        children: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _abrirPaginaGPS,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
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
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Adicione os diferenciais aqui',
                  ),
                  controller: _diferenciaisController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _cepController,
                  decoration: InputDecoration(
                      labelText: 'CEP',
                      suffixIcon: _loading
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ))
                          : IconButton(
                              onPressed: _findCep,
                              icon: const Icon(Icons.search),
                            )),
                  inputFormatters: [_cepFormatter],
                  validator: (String? value) {
                    if (value == null ||
                        value.isEmpty ||
                        !_cepFormatter.isFill()) {
                      return 'Informe um cep valido';
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: _bairroController,
                  decoration: InputDecoration(labelText: 'Bairro'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _logradouroController,
                    decoration: InputDecoration(labelText: 'Logradouro'),
                  )),
            ],
          ),
        ],
      );

  Future<void> _findCep() async {
    setState(() {
      _loading = true;
    });
    try {
      _cep = await findCepAsObject(_cepFormatter.getUnmaskedText());

      // widget.pontoturistico.latitude = _latitudeController.text;
      // widget.pontoturistico.longitude = _longitudeController.text;
      // widget.pontoturistico.nomepontomapa = _nomePontoMapaController.text;
      widget.pontoturistico.logradouro = _cep!.logradouro ?? "";
      widget.pontoturistico.bairro = _cep!.bairro ?? "";
      widget.pontoturistico.cep = _cep!.cep ?? "";

    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro ao consultar CEP')));
    }
    setState(() {
      _loading = false;
    });
  }

  Future<Cep> findCepAsObject(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      return Cep.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
