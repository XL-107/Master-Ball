import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'newtable.db');

    return openDatabase(
      path,
      version: 1,
      
      onConfigure:(db) async {
        db.execute('DROP TABLE IF EXISTS pokemon_test');
      },
      onOpen: (db) async {
        await db.execute('''
          CREATE TABLE pokemon_test (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            type1 TEXT NOT NULL,
            type2 TEXT
          )
        ''');
        final data = await rootBundle.loadString('assets/pokemon_test.sql');
        final lines = data.split('\n');
        Batch batch = db.batch();
        for (var i=8; i<1033; i++){
          batch.rawInsert(lines[i]);
        }
        await batch.commit(noResult: true);
      },
    );
  }

  Future<List<Map<String, dynamic>>> getPokemon() async {
    final db = await initDB();
    return db.query('pokemon_test');
  }

  Future<String> getNameAtIndex(int index) async {
    final db = await initDB();
    final result = await db.query('pokemon_test', where: 'id = ?', whereArgs: [index+1]);
    return result[0]['name'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.purpleAccent, title: Text('Pokedex')),
        body: ListView.builder(
          itemCount: 1025,
          itemBuilder:(BuildContext context, int index) {
            return FutureBuilder<String>(
              future: getNameAtIndex(index),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 50,
                    child: Text("Loading..."), //data has yet to load
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Container(
                    height: 50,
                    child: Text("no snapshot data"),
                  );
                }

                return Container(
                  height: 50,
                  child: Text(snapshot.data!),
                );
              }
            );
            
          }
        )
      ),
    );
  }
}