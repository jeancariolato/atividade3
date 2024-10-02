import 'package:flutter/material.dart';

class listCardDestiny extends StatelessWidget {
  final String nome;
  final double km;
  final Function() onRemoved;

  const listCardDestiny(
      {required this.nome,
      required this.km,
      required this.onRemoved,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: (){
        onRemoved();
      },
      child:  Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 15, 35, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.pin_drop_outlined,
              color: Colors.orangeAccent,
            ),
            Text(
              nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$km",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Quilômetros",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    )
    );
    
    
   
  }
}
