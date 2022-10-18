import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsPage extends StatefulWidget {
  const GpsPage({Key? key}) : super(key: key);

  static const ROUTE_NAME = '/gps';

  _GpsPageState createState() => _GpsPageState();
}

  class _GpsPageState extends State<GpsPage> {
    final _linhas = <String>[];


    @override
    void initState() {
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Usando GPS'),
        ),
        body: _criarBody(),
      );
    }

    Widget _criarBody() =>
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: _obterUltimaLocalizacao,
                  child: Text('Obter a ultima localizacao conhecida (cache)')
              ),
              ElevatedButton(
                  onPressed: _limparLog,
                  child: Text('Limpar Log')
              ),
              const Divider(),
              Expanded(
                  child:ListView.builder(
                    shrinkWrap: true,
                      itemCount: _linhas.length,
                      itemBuilder: (_,index)=> Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(_linhas[index]),
                      )
                  ))
            ],
          ),
        );

    _obterUltimaLocalizacao() async {
      bool permissoesPermitidas = await _permissoesPermitidas();
      if(!permissoesPermitidas){
        return;
      }

      Position? position = await Geolocator.getLastKnownPosition();
      
      setState(() {
        if(position == null){
          _linhas.add('Nenhuma localização encontrada');
        }else{
          _linhas.add('Latitude: ${position.latitude} | Longitude: ${position.longitude} ');
        }
      });
    }

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
        _mostrarMensagem('Para utilizar esse recurso, você deverá acessar as configurações e permitir o GPs');
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
          builder: (_) => AlertDialog(
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


    void _limparLog(){
      setState(() {
        _linhas.clear();
      });
    }
}


