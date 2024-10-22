class Gasolina {
  final int? id;
  final String tipo;
  double valor;

  Gasolina({this.id, required this.tipo, required this.valor});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'valor': valor,
    };
  }

  static Gasolina fromMap(Map<String, dynamic> map) {
    return Gasolina(
      id: map['id'],
      tipo: map['tipo'],
      valor: map['valor'],
    );
  }
}

