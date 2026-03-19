import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'pokemon.dart';

class DatabaseAccess{
  //vars
  final int loadedAtOnce = 50; //the minimum number of simultaneously loaded entries
  late List<Pokemon> loaded;

  //init
  DatabaseAccess(){
    loaded = List<Pokemon>.empty(growable: true);
  }

  //funcs
  Future<Database> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, "MasterBall.db");

    // Check if DB already exists
    final exists = await File(dbPath).exists();

    if (!exists) {
      //Copy from assets onto machine's local files
      ByteData data = await rootBundle.load("assets/MasterBall.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    // Open the database (READ-ONLY optional)
    return await openDatabase(dbPath, readOnly: true);
  }

  Future<List<Map<String, dynamic>>> getPokemon() async { //get all data for all pokemon
    final db = await initDB();
    return db.query('expanded_pokemon_test');
  }

  /*
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
  */

  Future<String> getNameAtIndex(int index) async { //get only the name of a pokemon of a specified id
    final listIndex = loaded.indexWhere((element) => element.number==index+1);
    String output = "Not Found"; //Placeholder text doubles as error checking
    if (listIndex==-1){
      final db = await initDB();
      final result = await db.query('expanded_pokemon_test', where: 'Number = ?', whereArgs: [index+1]);
      
      //Turn result into Pokemon object, in case we want to perform operations on it down the line, like add it to saved teams
      final Pokemon pkmnResult =
        Pokemon(index+1, result[0]['Name'] as String, [], [], [result[0]['Type1'] as String, result[0]['Type2'] as String], 
                [result[0]['HP'] as int, result[0]['Attack'] as int, result[0]['Defense'] as int, result[0]['SP.Attack'] as int, 
                result[0]['SP.Defense'] as int, result[0]['Speed'] as int]);
      loaded.add(pkmnResult);
      output = pkmnResult.name;
    }
    else{
      output = loaded[listIndex].name;
    }
    return output;
  }
}