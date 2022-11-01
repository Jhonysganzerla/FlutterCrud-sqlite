import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jhonyproject/Model/ponto_turistico_model.dart';
import 'package:jhonyproject/Pages/mapas_page.dart';
import 'package:maps_launcher/maps_launcher.dart';

class GpsPage extends StatefulWidget {
  final PontoTuristico pontoturistico;

  const GpsPage({Key? key, required this.pontoturistico}) : super(key: key);

  static const ROUTE_NAME = '/gps';

  _GpsPageState createState() => _GpsPageState();
}

  class _GpsPageState extends State<GpsPage> {
    final _linhas = <String>[];

    StreamSubscription<Position>?  _subscription;

    bool get _monitorarLocalizacao => _subscription != null;
    Position? _localizacaoAtual;
    final _controller = TextEditingController();

    String get _textoLocalizacao => _localizacaoAtual == null ? '' : 'Latitude: ${_localizacaoAtual!.latitude} | Longitude:  ${_localizacaoAtual!.longitude}';

    @override
    void initState() {
      preencheController();

      super.initState();
    }

    preencheController() async{
      if(_localizacaoAtual == null){
        Position a = new Position
          (longitude: double.parse(widget.pontoturistico.latitude != "" ?
            widget.pontoturistico.latitude : "0"),
            latitude: double.parse(
                widget.pontoturistico.longitude != "" ?
                widget.pontoturistico.longitude : "0"
            ),
            timestamp: null, accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
          setState(() {
            _localizacaoAtual = a;
            _linhas.add('Latitude: ${widget.pontoturistico.latitude} | Longitude: ${widget.pontoturistico.longitude} ');
          });
      }
    }

    Future<bool> _onVoltarClick() async {
      String lat = _localizacaoAtual != null ? _localizacaoAtual!.latitude.toString() : '';
      String long = _localizacaoAtual != null ? _localizacaoAtual!.longitude.toString() : '';
      String mapa = _controller != null ? _controller.text : '';

      widget.pontoturistico.latitude = lat;
      widget.pontoturistico.longitude = long;
      widget.pontoturistico.nomepontomapa = mapa;

      Navigator.of(context).pop(widget.pontoturistico);
      return true;
    }
    @override
    Widget build(BuildContext context) {
      return
        WillPopScope(
          onWillPop: _onVoltarClick,
          child: (
              Scaffold(
                appBar: AppBar(
                  title: const Text('Usando GPS'),
                ),
                body: _criarBody(),
              )
          ),
        );
    }

    Widget _criarBody() =>
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: _obterLocalizacaoAtual,
                  child: const Text('Obter localização Atual')
              ),

              if(this._localizacaoAtual != null)
                Padding(padding: const  EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(child: Text(_textoLocalizacao),),
                    ElevatedButton(
                        onPressed: _abrirMapaInterno,
                        child: const Icon(Icons.map),
                    ),
                    ],

                  ),
    ),
              Padding(padding: const  EdgeInsets.all(10),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Endereço ou ponto de referencia',
                    suffixIcon: IconButton(icon:
                      Icon(Icons.map),
                      tooltip: 'Abrir no Mapa',
                      onPressed: _abrirCoordenadasNoMapa,
                    )
                  ),
                ),

              ),




    // ElevatedButton(
              //     onPressed: _obterUltimaLocalizacao,
              //     child: const Text('Obter a ultima localizacao conhecida (cache)')
              // ),
              // Row(
              //   children: [
              //
              //     Padding(padding: const EdgeInsets.all(10), ),
              //     ElevatedButton(
              //         onPressed: _monitorarLocalizacao ? _pararMonitoramento : _iniciarMonitoramento,
              //         child: Text(_monitorarLocalizacao ? 'Parar Monitoramento' : 'Iniciar Monitoramento')
              //     ),
              //
              //   ],
              // ),

              ElevatedButton(
                  onPressed: _limparLog,
                  child: const Text('Limpar Log')
              ),
              const Divider(),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _linhas.length,
                      itemBuilder: (_, index) =>
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(_linhas[index]),
                          )
                  ))
            ],

          ),
        );

    // _obterUltimaLocalizacao() async {
    //   bool permissoesPermitidas = await _permissoesPermitidas();
    //   if (!permissoesPermitidas) {
    //     return;
    //   }
    //
    //   Position? position = await Geolocator.getLastKnownPosition();
    //
    //   setState(() {
    //     if (position == null) {
    //       _linhas.add('Nenhuma localização encontrada');
    //     } else {
    //       _linhas.add('Latitude: ${position.latitude} | Longitude: ${position
    //           .longitude} ');
    //     }
    //   });
    // }

    Future<bool> _permissoesPermitidas() async {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          _mostrarMensagem(
              'Não será possivel utilizar o serviço de localização por falta de permissão');

          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _mostrarMensagem(
            'Para utilizar esse recurso, você deverá acessar as configurações e permitir o GPs');
        Geolocator.openAppSettings();
        return false;
      }
      return true;
    }

    void _mostrarMensagem(String mensagem) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem)
        ),
      );
    }

    Future<void> _showDialogMessage(String mensagem) async {
      await showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: const Text('Atenção'),
                content: Text(mensagem),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              )
      );
    }

    void _limparLog() {
      setState(() {
        _linhas.clear();
      });
    }

    Future<bool> _servicoHabilitado() async {
      bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicoHabilitado) {
        await _showDialogMessage('Para utilizar este recurso você deve '
            'habilitar o serviço de localização do dispositivo');
        Geolocator.openLocationSettings();
        return false;
      }
      return true;
    }

    void _obterLocalizacaoAtual() async {
      bool servicohabilitado = await _servicoHabilitado() && await _permissoesPermitidas();
      if (!servicohabilitado) {
        return;
      }
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        _localizacaoAtual = position;
        _linhas.add('Latitude: ${position!.latitude} | Longitude: ${position!.longitude} ');
      });
    }
    //
    // void _iniciarMonitoramento(){
    //   _subscription = Geolocator.getPositionStream(
    //     locationSettings: LocationSettings(
    //       distanceFilter: 30,
    //       timeLimit: Duration(seconds: 2),
    //     ),
    //   ).listen((Position position) {
    //     setState(() {
    //       _linhas.add('Latitude: ${position!.latitude} | Longitude: ${position!.longitude} ');
    //     });
    //   });
    //
    // }
    //
    // void _pararMonitoramento(){
    //   _subscription!.cancel();
    //   }


    _abrirMapaInterno(){
      if(_localizacaoAtual == null){
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder:
      (BuildContext context) => MapasPage(latitude: _localizacaoAtual!.latitude
      , longitude: _localizacaoAtual!.longitude)
      ));
    }

    _abrirCoordenadasNoMapa() async{
      bool servicohabilitado = await _servicoHabilitado() && await _permissoesPermitidas();
      if (!servicohabilitado) {
        return;
      }


      if(_controller.text.trim().isEmpty){
        return;
      }

      MapsLauncher.launchCoordinates(
        _localizacaoAtual!.latitude, _localizacaoAtual!.longitude
      );
      return;
    }


    _abrirMapaExterno(){
      if(_controller.text.trim().isEmpty){
        return;
      }

      MapsLauncher.launchQuery(_controller.text);

    }

  }


