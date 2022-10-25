import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jhonyproject/Model/ponto_turistico_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapasPage extends StatefulWidget {

  final double latitude;
  final double longitude;

   MapasPage({Key? key, required this.latitude, required this.longitude}) : super (key: key);

   _MapasPageState createState() => _MapasPageState();
}

class _MapasPageState extends State<MapasPage> {

  final _controller = Completer<GoogleMapController>();
  StreamSubscription<Position>? _streamSubscription;

  void initState() {
    super.initState();

    _monitorarLocalizacao();
  }

  void dispose(){
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mapa Interno'),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude,widget.longitude),
            zoom: 15,
          ) ,
          onMapCreated: (GoogleMapController controler){
            _controller.complete(controler);
          },
          myLocationEnabled: true,
        ),
    );
  }

  Widget _criarBody() => ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text('Campo para ordenação'),
          ),
        ],
      );

  _monitorarLocalizacao(){
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
        timeLimit: Duration(seconds: 5),
    );
    _streamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((event) async {
        final controller = await _controller.future;
        final zoom = await controller.getZoomLevel();
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:
          LatLng(event.latitude,event.longitude),
        )));
    });
  }
}
