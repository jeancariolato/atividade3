import 'package:flutter/material.dart';

class listCard extends StatelessWidget {
  final String nome;
  final double km;
  final Function() onRemoved;


  const listCard({required this.nome, required this.km, required this.onRemoved, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 255, 211, 146),
                child: Icon(
                  Icons.directions_car_outlined,
                  color: Color.fromARGB(255, 97, 58, 0),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange),
                    ),
                    Text(
                      'Quilômetros rodados por Litro: $km',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  onRemoved();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(
            thickness: 1,
            color: Color.fromARGB(255, 211, 211, 211),
          )
        ],
      ),
    );
  }
}
