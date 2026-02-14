import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      },
    );
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
          future: getPokemon(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
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
