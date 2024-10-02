import 'package:atividade3/CalcScreen.dart';
import 'package:atividade3/Destiny.dart';
import 'package:atividade3/ListCars.dart';
import 'package:atividade3/ListDestiny.dart';
import 'package:flutter/material.dart';
import 'Car.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indexSelecionado = 0;

  final List<Car> _carros = [
    Car(nome: "BMW", KM_perL: 25.0),
    Car(nome: "Gol", KM_perL: 25.0),
  ];

  final List<Destiny> _destinos = [
    Destiny(nomeCidade: "Florianopolis", KM: 1000),
    Destiny(nomeCidade: "Rosário do Sul", KM: 35)
  ];

  void _itemSelecionado(int index) {
    setState(() {
      _indexSelecionado = index;
    });
  }

  // REMOVER CARRO
  void _removerCarro(int index) {
    setState(() {
      _carros.removeAt(index);
    });
  }

  // INSERIR CARRO
  void _inserirCarro(Car novoCarro) {
    setState(() {
      _carros.add(novoCarro);
    });
  }

  // INSERIR DESTINO
  void _inserirDestino(Destiny novoDestino) {
    setState(() {
      _destinos.add(novoDestino);
    });
  }

  // REMOVER DESTINO
  void _removerDestino(int index) {
    setState(() {
      _destinos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      CalcScreen(
        carros: _carros,
        destinos: _destinos,
    
      ),
      listCars(
        carros: _carros,
        onRemove: _removerCarro,
        onInsert: _inserirCarro,
      ),
      listDestiny(
        destinos: _destinos,
        onInsert: _inserirDestino,
        onRemove: _removerDestino,
      ),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions[_indexSelecionado],
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
        currentIndex: _indexSelecionado,
        selectedItemColor: Colors.orange,
        onTap: _itemSelecionado,
      ),
    );
  }
}
