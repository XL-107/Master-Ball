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
    final path = join(dbPath, 'newtable.db'); //name of file shouldn't really matter

    return openDatabase(
      path,
      version: 1,
      
      onConfigure:(db) async {
        ///This deletes and re-creates the database each time
        ///The final version won't do this, but it's useful for
        ///now since we will be constantly updating how the db is built.
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
        //read the file like a text file and split it into a list of strings by line
        final data = await rootBundle.loadString('assets/pokemon_test.sql');
        final lines = data.split('\n');
        Batch batch = db.batch();
        for (var i=8; i<1033; i++){
          batch.rawInsert(lines[i]); //run the strings read from the file like an SQL format command
        }
        await batch.commit(noResult: true);
      },
    );
  }

  Future<List<Map<String, dynamic>>> getPokemon() async { //get all data for all pokemon
    final db = await initDB();
    return db.query('pokemon_test');
  }

  Future<String> getNameAtIndex(int index) async { //get only the name of a pokemon of a specified id
    final db = await initDB();
    final result = await db.query('pokemon_test', where: 'id = ?', whereArgs: [index+1]);
    return result[0]['name'] as String; //if multiple results are returned (ie. mutliple forms) the first is selected
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.purpleAccent, title: Text('Pokedex')),
        body: ListView.builder(
          itemCount: 1025, //limit list view to maximum number of pokemon
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
                    child: Text("No data available"), //this text should never occur if the code works properly
                  );
                }

                return Container(
                  height: 50,
                  child: Text(snapshot.data!), //confirm that the data is not null and pass it in
                );
              }
            );
            
          }
        )
      ),
    );
  }
}