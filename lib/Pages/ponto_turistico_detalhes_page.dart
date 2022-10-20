import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jhonyproject/Model/ponto_turistico_model.dart';

class PontoTuristicoDetalhePage extends StatefulWidget{
  static const ROUTE_NAME = '/detalhes';
  final PontoTuristico pontoturistico;

  const PontoTuristicoDetalhePage({Key? key, required this.pontoturistico}) : super(key: key);

  _PontoTuristicoDetalhePageState createState() => _PontoTuristicoDetalhePageState();

}

class _PontoTuristicoDetalhePageState extends State<PontoTuristicoDetalhePage>{
  final _diferenciaisController = TextEditingController();
  final _detalhesController = TextEditingController();

  Widget build(BuildContext context){
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

    Navigator.of(context).pop({_diferenciaisController.text, _detalhesController.text});
    return true;
  }

  Widget _criarBody() =>
      ListView(
        children: [
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