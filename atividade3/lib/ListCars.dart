import 'package:atividade3/ListCardWidget.dart';
import 'package:flutter/material.dart';
import 'Car.dart';
import 'package:atividade3/DatabaseHelper.dart';

class listCars extends StatefulWidget {

  const listCars({super.key});

  @override
  State<listCars> createState() => _listCarsState();
}

class _listCarsState extends State<listCars> {
  List<Car> carros = [];

//INICIALIZADOR
  @override
 void initState(){
  super.initState();
  _loadCars();
 }

//METODO PARA CARREGAR CARROS DO BANCO
 Future<void> _loadCars() async {
    final db = DatabaseHelper.instance;
    final loadedCars = await db.getCars();
    setState(() {
      carros = loadedCars;
    });
  }

  //METODO PARA REMOVER CARRO
  Future<void> _removeCar(int index) async {
  final db = DatabaseHelper.instance;
  await db.deleteCar(carros[index].id!);
  setState(() {
    carros.removeAt(index);
  });
}

//METODO PARA INSERIR CARRO
Future<void> _insertCar(Car car) async {
  final db = DatabaseHelper.instance;
  final id = await db.insertCar(car);
  setState(() {
    carros.add(Car(id: id, nome: car.nome, KM_perL: car.KM_perL));
  });
}

//CONTROLADORES NOME E KM
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  //METODO PARA ABRIR MODAL
  void openModal(BuildContext scaffoldContext) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0), // Remove cantos arredondados
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(label: Text("Nome do Carro")),
                  controller: _nomeController,
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("KMs por Litro")),
                  controller: _kmController,
                ),
                ElevatedButton(
                  child: const Text("Salvar"),
                  onPressed: () {
                    //Variaveis para receber os valores dos controllers
                    final String nome = _nomeController.text;
                    final double? km = double.tryParse(_kmController.text);

                    if (nome.isNotEmpty && km != null) {
                      //Inserir carro com os valores recebidos
                      _insertCar(Car(nome: nome, KM_perL: km));

                      //Limpar formulario
                      _nomeController.clear();
                      _kmController.clear();

                      //Fechar modal
                      Navigator.pop(context);

                      // Exibir snackbar de sucesso
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        const SnackBar(content: Text("Carro adicionado com sucesso!"))
                      );
                    } else {
                      Navigator.pop(context);
                      //Exibir snackbar de erro
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        const SnackBar(content: Text("Preencha os campos corretamente!"))
                        );
              
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Lista de carros",
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true),
      body: ListView.builder(
        itemCount: carros.length,
        itemBuilder: (context, index) {
          return listCard(
            nome: carros[index].nome,
            km: carros[index].KM_perL,
            onRemoved: () => _removeCar(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openModal(context);
        },
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
