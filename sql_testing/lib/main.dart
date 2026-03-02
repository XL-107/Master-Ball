import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Map<String, dynamic>>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = getPokemon();
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'test.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pokemon (
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');

        await db.insert('pokemon', {'id': 1, 'name': 'Bulbasaur'});
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> registerUser(String username, String password) async {
    final db = await initDB();
    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await initDB();

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getPokemon() async {
    final db = await initDB();
    return db.query('pokemon');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("SQLite Test")),
        body: FutureBuilder(
          future: _pokemonFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final data = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]['name']),
                );
              },
            );
          },
        ),
      ),
    );
  }
  
}