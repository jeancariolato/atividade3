class Destiny {
  final int? id;
  final String nomeCidade;
  final double KM;

  Destiny({this.id, required this.nomeCidade, required this.KM});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeCidade': nomeCidade,
      'KM': KM,
    };
  }

  static Destiny fromMap(Map<String, dynamic> map) {
    return Destiny(
      id: map['id'],
      nomeCidade: map['nomeCidade'],
      KM: map['KM'],
    );
  }
}