import 'package:atividade3/ListCars.dart';
import 'package:atividade3/ListDestiny.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _IndexSelecionado = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Text('Tela 1'),
    listCars(),
    listDestiny(),
  ];

  void _ItemSelecionado(int index) {
    setState(() {
      _IndexSelecionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
              
              },
              icon: Icon(Icons.add))),
      body: Center(
        child: _widgetOptions[_IndexSelecionado],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Cálculo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Carros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
            label: 'Destinos',
          ),
        ],
        currentIndex: _IndexSelecionado,
        selectedItemColor: Colors.orange,
        onTap: _ItemSelecionado,
      ),
    );
  }
}
