import 'package:flutter/material.dart';
import 'package:jhonyproject/Pages/filtro_page.dart';
import 'package:jhonyproject/Pages/ponto_turistico_page.dart';


//TODO ADDICIONAR --no-sound-null-safety aos args quando rodar

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Pontos Turisticos',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: PontoTuristicoPage(),
      routes: {
        FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),
      },
    );
  }
}