import 'package:atividade3/Car.dart';
import 'package:atividade3/Destiny.dart';
import 'package:atividade3/Gasolina.dart';
import 'package:flutter/material.dart';
import 'package:atividade3/DatabaseHelper.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({
    super.key,
  });

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  List<Car> carros = [];
  List<Destiny> destinos = [];
  List<Gasolina> gasolinas = [];
  String? _carroSelecionado;
  String? _destinoSelecionado;
  double _custoComum = 0;
  double _custoDiesel = 0;

  // Controladores de Texto
  final TextEditingController _comumController = TextEditingController();
  final TextEditingController _dieselController = TextEditingController();

  //Carrergando metodos do databasehelper
  Future<List<Car>> _getCars() async {
    final db = DatabaseHelper.instance;
    return await db.getCars();
  }

  Future<List<Destiny>> _getDestinies() async {
    final db = DatabaseHelper.instance;
    return await db.getDestinies();
  }

  @override
  void initState() {
    super.initState();
    //inicializar as gasolinas
    gasolinas.add(Gasolina(tipo: "Gasolina Comum", valor: 4.5));
    gasolinas.add(Gasolina(tipo: "Diesel", valor: 5.5));
    // Inicializa os controladores de texto com os valores padrões
    _comumController.text = gasolinas[0].valor.toString();
    _dieselController.text = gasolinas[1].valor.toString();

//inicializar os carros atualizados.
    _getCars().then((value) {
      setState(() {
        carros = value;
      });
    });

    _getDestinies().then((value) {
      setState(() {
        destinos = value;
      });
    });

    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    carros = await db.getCars();
    destinos = await db.getDestinies();
    List<Gasolina> gasolinasAtualizadas = await db.getGasolinas(); // Adicione este método para obter os preços atualizados
    setState(() {
      // Atualiza os preços das gasolinas
      if (gasolinasAtualizadas.isNotEmpty) {
        gasolinas[0].valor = gasolinasAtualizadas[0].valor;
        gasolinas[1].valor = gasolinasAtualizadas[1].valor;
        _comumController.text = gasolinas[0].valor.toString();
        _dieselController.text = gasolinas[1].valor.toString();
      }
    });

    setState(() {});
  }

  // Método para exibir modal (alterar preço gasolina)
  void openModal(BuildContext scaffoldContext) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text("Defina os preços das gasolinas."),
                      const SizedBox(height: 40),
                      // Gasolina comum
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Comum (R\$)"),
                          const SizedBox(width: 35),
                          SizedBox(
                            width: 100,
                            height: 80,
                            child: TextField(
                              style: const TextStyle(fontSize: 35),
                              controller: _comumController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Gasolina diesel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Diesel (R\$)"),
                          const SizedBox(width: 35),
                          SizedBox(
                            width: 100,
                            height: 80,
                            child: TextField(
                              style: const TextStyle(fontSize: 35),
                              controller: _dieselController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 150),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(200, 50),
                          ),
                          onPressed: () {
                            setState(() {
                              gasolinas[0].valor =
                                  double.parse(_comumController.text);
                              gasolinas[1].valor =
                                  double.parse(_dieselController.text);
                            });
                            Navigator.pop(context); // Fechar modal
                          },
                          child: const Text("Confirmar",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

//METODO PARA CALCULAR CUSTOS DA VIAGEM
  void calcularCusto() {
    if (_carroSelecionado != null && _destinoSelecionado != null) {
      Car carro = carros.firstWhere((car) => car.nome == _carroSelecionado);
      Destiny destino =
          destinos.firstWhere((dest) => dest.nomeCidade == _destinoSelecionado);

      //Calcular quantidade de Litros necessarios
      double litrosNecessarios = destino.KM / carro.KM_perL;

      //Calcula o custo para os combustiveis
      setState(() {
        _custoComum = litrosNecessarios * gasolinas[0].valor;
        _custoDiesel = litrosNecessarios * gasolinas[1].valor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(height: 30),

          // Botão de alterar preço
          Container(
            margin: const EdgeInsets.only(top: 15, left: 170),
            width: 140,
            height: 35,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                side: const BorderSide(color: Colors.orange, width: 1.0),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                openModal(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.orange,
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Alterar preço",
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  )
                ],
              ),
            ),
          ),
          // Container com as variáveis
          Container(
            margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 236, 207),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.opacity,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Comum"),
                      // Preço atualizado da gasolina comum
                      Text(gasolinas[0].valor.toString()),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Diesel"),
                      // Preço atualizado do diesel
                      Text(gasolinas[1].valor.toString()),
                    ],
                  )
                ], 
              ),
            ),
          ),
          // Container de 'Calcular' com dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Calcular",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text(
                "Selecione um carro e um destino, e veja seu custo.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 300,
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Selecione um carro"),
                  value: _carroSelecionado,
                  items: carros.map((Car carro) {
                    return DropdownMenuItem<String>(
                      value: carro.nome,
                      child: Text(carro.nome),
                    );
                  }).toList(),
                  onChanged: (String? novoCarro) {
                    setState(() {
                      _carroSelecionado = novoCarro;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Selecione um destino"),
                  value: _destinoSelecionado,
                  items: destinos.map((Destiny destino) {
                    return DropdownMenuItem<String>(
                      value: destino.nomeCidade,
                      child: Text(destino.nomeCidade),
                    );
                  }).toList(),
                  onChanged: (String? novoDestino) {
                    setState(() {
                      _destinoSelecionado = novoDestino;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Exibir o custo total
          Padding(
            padding: const EdgeInsets.only(right: 35, top: 20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Total a ser gasto:",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Gasolina Comum:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "BRL${_custoComum.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Diesel:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "BRL${_custoDiesel.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 60),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                calcularCusto();
              },
              child: const Text(
                "Calcular",
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
        ],
      ),
    ));
  }
}
