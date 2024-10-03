import 'package:atividade3/Car.dart';
import 'package:atividade3/Destiny.dart';
import 'package:flutter/material.dart';

class CalcScreen extends StatefulWidget {
  final List<Car> carros;
  final List<Destiny> destinos;

  const CalcScreen({
    super.key,
    required this.carros,
    required this.destinos,
  });

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  String? _carroSelecionado;
  String? _destinoSelecionado;
  double _custoComum = 0;
  double _custoDiesel = 0;

  // Variaveis da gasolina
  double precoGasolinaComum = 5.50;
  double precoDiesel = 6.30;

  // Controladores de Texto
  final TextEditingController _comumController = TextEditingController();
  final TextEditingController _dieselController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores de texto com os valores padrões
    _comumController.text = precoGasolinaComum.toString();
    _dieselController.text = precoDiesel.toString();
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
                              precoGasolinaComum =
                                  double.parse(_comumController.text);
                              precoDiesel = double.parse(_dieselController.text);
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
  void calcularCusto(){
    if(_carroSelecionado !=null && _destinoSelecionado != null){
      Car carro = widget.carros.firstWhere((car) => car.nome == _carroSelecionado);
      Destiny destino = widget.destinos.firstWhere((dest) => dest.nomeCidade == _destinoSelecionado);

      //Calcular quantidade de Litros necessarios
      double litrosNecessarios = destino.KM / carro.KM_perL;

      //Calcula o custo para os combustiveis
      setState(() {
        _custoComum = litrosNecessarios * precoGasolinaComum;
        _custoDiesel = litrosNecessarios * precoDiesel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
      children: [
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
            onPressed: (){
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
                    const Text("Comum"),
                    // Preço atualizado da gasolina comum
                    Text(precoGasolinaComum.toString()),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Diesel"),
                    // Preço atualizado do diesel
                    Text(precoDiesel.toString()),
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
                hint: Text("Selecione um carro"),
                value: _carroSelecionado,
                items: widget.carros.map((Car carro) {
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
                hint: Text("Selecione um destino"),
                value: _destinoSelecionado,
                items: widget.destinos.map((Destiny destino) {
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
        SizedBox(height: 20),
        // Exibir o custo total
        Padding(
          padding: EdgeInsets.only(right: 35, top: 20),
          child: Column(
            children: [
              Row(
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
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Gasolina Comum:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "BRL${_custoComum.toStringAsFixed(2)}",
                    style: TextStyle(
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
                  Text(
                    "Diesel:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "BRL${_custoDiesel.toStringAsFixed(2)}",
                    style: TextStyle(
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
        SizedBox(height: 50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(300, 60),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),
            ),
          ),
          onPressed: (){
            calcularCusto();
          },
          child: Text(
            "Calcular",
            style: TextStyle(
              color: Colors.white,
            ),
            )
          )
      ],
    )
    );
  }
}
