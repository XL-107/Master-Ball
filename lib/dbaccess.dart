import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseAccess{
  //vars
  final int loadedAtOnce = 50; //the minimum number of simultaneously loaded entries
  late List<Map<String, dynamic>> loaded;

  //init
  DatabaseAccess(){
    loaded = List<Map<String, dynamic>>.empty(growable: true);
  }

  //funcs
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
        db.execute('DROP TABLE IF EXISTS expanded_pokemon_test');
      },
      onOpen: (db) async {
        await db.execute('''
          CREATE TABLE expanded_pokemon_test (
            Number	INTEGER NOT NULL,
            Name	TEXT NOT NULL,
            Form	TEXT,
            Type1	TEXT NOT NULL,
            Type2	TEXT,
            HP	INTEGER NOT NULL,
            Attack	INTEGER NOT NULL,
            Defense	INTEGER NOT NULL,
            SPAttack	INTEGER NOT NULL,
            SPDefense	INTEGER NOT NULL,
            Speed	INTEGER NOT NULL,
            PRIMARY KEY (Number,Form)
          )

        ''');
        //read the file like a text file and split it into a list of strings by line
        final data = await rootBundle.loadString('assets/expanded_pokemon_test.sql');
        final lines = data.split('\n');
        Batch batch = db.batch();
        for (var i=15; i<lines.length-1; i++){
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
    String output = 'Name Not Found';
    if (loaded.isEmpty){
      final db = await initDB();
      for (int i=index+1; i<=1025 && i<index+loadedAtOnce; i++){
        final result = await db.query('expanded_pokemon_test', columns: ["Name"], where: 'Number = ?', whereArgs: [i]);
        loaded.add(result[0]);
      }
      output = loaded[0]['Name'] as String;
    }
    
    else if(index+1 < loaded[0]['Number']){ //requested pokemon is not loaded (id is too low)
      final db = await initDB();
      if ((loaded[0]['Number'] as int) - (index + 1) < 10){ //simply load everything between the requested and first loaded pokemon
        for (int i=index+1; i<loaded[0]['Number']; i++){
          final result = await db.query('expanded_pokemon_test', columns: ["Name"], where: 'Number = ?', whereArgs: [i]);
          loaded.insert(0, result[0]);
        }
        output = loaded[0]['Name'] as String;
      }

      else{ //requested is so far away from what's loaded, we'll just clear out loaded and start from scratch
        loaded = List<Map<String, dynamic>>.empty(growable: true);
        return getNameAtIndex(index); //loaded is now empty, so the first if block will execute
      }
    }

    else if(index+1 > loaded[loaded.length-1]['Number']){ //id is too high
      final db = await initDB();
      if ((index + 1) - (loaded[0]['Number'] as int) < 10){ //simply load everything between the requested and first loaded pokemon
        for (int i=loaded[0]['Number']+1; i<=index+1; i++){
          final result = await db.query('expanded_pokemon_test', columns: ["Name"], where: 'Number = ?', whereArgs: [i]);
          loaded.add(result[0]);
        }
        output = loaded[0]['Name'] as String;
      }

      else{ //requested is so far away from what's loaded, we'll just clear out loaded and start from scratch
        loaded = List<Map<String, dynamic>>.empty(growable: true);
        return getNameAtIndex(index); //loaded is now empty, so the first if block will execute
      }
    }

    else{ //requested pokemon is loaded
      for (Map<String, dynamic> element in loaded){
        if (element['Number']==index+1){
          return element['Name'];
        }
      }
      
      //somehow, requested pokemon was not loaded
      final db = await initDB();
      final result = await db.query('expanded_pokemon_test', columns: ["Name"], where: 'Number = ?', whereArgs: [index+1]);
      output = result[0]['Name'] as String;
    }

    return output;
  }
}