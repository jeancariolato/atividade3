import 'package:atividade3/Destiny.dart';
import 'package:atividade3/ListCardDestiny.dart';
import 'package:flutter/material.dart';
import 'package:atividade3/DatabaseHelper.dart';

class listDestiny extends StatefulWidget {
  const listDestiny({super.key});

  @override
  State<listDestiny> createState() => _listDestinyState();
}

class _listDestinyState extends State<listDestiny> {
  List<Destiny> destinos = [];

  @override
  void initState() {
    super.initState();
    _loadDestinies();
  }

  Future<void> _loadDestinies() async {
    final db = DatabaseHelper.instance;
    final loadedDestinies = await db.getDestinies();
    setState(() {
      destinos = loadedDestinies;
    });
  }

  Future<void> _removeDestiny(int index) async {
    final db = DatabaseHelper.instance;
    await db.deleteDestiny(destinos[index].id!);
    setState(() {
      destinos.removeAt(index);
    });
  }

  Future<void> _insertDestiny(Destiny destiny) async {
  final db = DatabaseHelper.instance;
  final id = await db.insertDestiny(destiny);
  setState(() {
    destinos.add(Destiny(id: id, nomeCidade: destiny.nomeCidade, KM: destiny.KM));
  });
}

  final TextEditingController _nomeCidadeControl = TextEditingController();
  final TextEditingController _KmCidadeControl = TextEditingController();

  void openModal(BuildContext scaffoldContext) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Column(
              children: [
                TextField(
                  decoration:
                      const InputDecoration(label: Text("Nome da cidade")),
                  controller: _nomeCidadeControl,
                ),
                TextField(
                  decoration:
                      const InputDecoration(label: Text("Distância (KM)")),
                  controller: _KmCidadeControl,
                ),
                ElevatedButton(
                    child: const Text("Salvar"),
                    onPressed: () {
                      final String nomeCidade = _nomeCidadeControl.text;
                      final double? km = double.tryParse(_KmCidadeControl.text);

                      if (nomeCidade.isNotEmpty && km != null) {
                        _insertDestiny(Destiny(nomeCidade: nomeCidade, KM: km));

                        _KmCidadeControl.clear();
                        _nomeCidadeControl.clear();

                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        //Exibir snackbar de erro
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Preencha os campos corretamente!")));
                      }
                    })
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Lista de Destinos",
          style: TextStyle(
            fontSize: 16,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: destinos.length,
          itemBuilder: (context, index) {
            return listCardDestiny(
              nome: destinos[index].nomeCidade,
              km: destinos[index].KM,
              onRemoved: () => _removeDestiny(index),
            );
          }),
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
