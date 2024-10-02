import 'package:atividade3/Destiny.dart';
import 'package:atividade3/ListCardDestiny.dart';
import 'package:flutter/material.dart';

class listDestiny extends StatefulWidget {
  final List<Destiny> destinos;
  final Function(Destiny) onInsert;
  final Function(int) onRemove;

  const listDestiny(
      {required this.destinos,
      required this.onInsert,
      required this.onRemove,
      super.key});

  @override
  State<listDestiny> createState() => _listDestinyState();
}

class _listDestinyState extends State<listDestiny> {

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
                  decoration: const InputDecoration(label: Text("Nome da cidade")),
                  controller: _nomeCidadeControl,
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("Distância (KM)")),
                  controller: _KmCidadeControl,
                ),
                ElevatedButton(
                    child: const Text("Salvar"),
                    onPressed: () {
                      final String nomeCidade = _nomeCidadeControl.text;
                      final double? km = double.tryParse(_KmCidadeControl.text);

                      if (nomeCidade.isNotEmpty && km != null) {
                        widget
                            .onInsert(Destiny(nomeCidade: nomeCidade, KM: km));

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
          itemCount: widget.destinos.length,
          itemBuilder: (context, index) {
            return listCardDestiny(
              nome: widget.destinos[index].nomeCidade,
              km: widget.destinos[index].KM,
              onRemoved: ()=> widget.onRemove(index),
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
