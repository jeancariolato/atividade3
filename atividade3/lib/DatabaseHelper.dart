import 'package:atividade3/Gasolina.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Car.dart';
import 'Destiny.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('calculadoraCarro.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //CRIANDO TABELAS
    //*Carros
    await db.execute('''
    CREATE TABLE cars(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      KM_perL REAL
    )
    ''');

//*Destinos
    await db.execute('''
    CREATE TABLE destinos(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeCidade TEXT,
      KM REAL
    )
    ''');
//*Gasolina
    await db.execute('''
      CREATE TABLE gasolina (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        valor REAL NOT NULL
      )
    ''');
  }

  Future<int> insertCar(Car car) async {
    final db = await instance.database;
    return await db.insert('cars', car.toMap());
  }

  Future<int> insertDestiny(Destiny destiny) async {
    final db = await instance.database;
    return await db.insert('destinos', destiny.toMap());
  }

  Future<List<Car>> getCars() async {
    final db = await instance.database;
    final maps = await db.query('cars');
    return List.generate(maps.length, (i) => Car.fromMap(maps[i]));
  }

  Future<List<Destiny>> getDestinies() async {
    final db = await instance.database;
    final maps = await db.query('destinos');
    return List.generate(maps.length, (i) => Destiny.fromMap(maps[i]));
  }

  // Método para remover um carro
  Future<void> deleteCar(int id) async {
    final db = await database;
    await db.delete(
      'cars',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método para remover um destino
Future<void> deleteDestiny(int id) async {
  final db = await database;
  await db.delete(
    'destinos', 
    where: 'id = ?',
    whereArgs: [id],
  );
}

//CRUD DA GASOLINA
Future<int> insertGasolina(Gasolina gasolina) async {
    final db = await database;
    return await db.insert('gasolina', gasolina.toMap());
  }

  Future<List<Gasolina>> getGasolinas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gasolina');

    return List.generate(maps.length, (i) {
      return Gasolina.fromMap(maps[i]);
    });
  }

  Future<int> updateGasolina(Gasolina gasolina) async {
    final db = await database;
    return await db.update(
      'gasolina',
      gasolina.toMap(),
      where: 'id = ?',
      whereArgs: [gasolina.id],
    );
  }

  Future<int> deleteGasolina(int id) async {
    final db = await database;
    return await db.delete(
      'gasolina',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}