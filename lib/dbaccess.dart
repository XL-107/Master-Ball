import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'pokemon.dart';

//HOW TO USE CLASS:
//Create a database object with "final db = DatabaseAccess();"
//Use the "getPokemonAtIndex(int)" function to get a Pokemon object (see pokemon.dart)

class DatabaseAccess{
  //vars
  final int loadedAtOnce = 50; //the minimum number of simultaneously loaded entries
  final int maxLoaded = 100; //the most that should be loaded in either direction of the current index
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

  Future<String> getNameAtIndex(int index) async { //get only the name of a pokemon of a specified id
    final listIndex = loaded.indexWhere((element) => element.number==index+1);
    String output = "Not Found"; //Placeholder text doubles as error checking
    if (listIndex==-1){
      final db = await initDB();
      final result = await db.query('expanded_pokemon_test', where: 'Number = ?', whereArgs: [index+1]);
      
      //Turn result into Pokemon object, in case we want to perform operations on it down the line, like add it to saved teams
      Pokemon pkmnResult = Pokemon(index+1, result[0]['Name'] as String, [], [], [result[0]['Type1'] as String, result[0]['Type2']==null ? "None" : result[0]['Type2'] as String],
                                  [result[0]['HP'] as int, result[0]['Attack'] as int, result[0]['Defense'] as int, 
                                  result[0]['SP.Attack'] as int, result[0]['SP.Defense'] as int, result[0]['Speed'] as int]);
      loaded.add(pkmnResult);
      output = pkmnResult.name;
    }
    else{
      output = loaded[listIndex].name;
    }

    while (loaded[0].number < index-maxLoaded){
      loaded.removeAt(0);
    }
    while (loaded[loaded.length-1].number > index+maxLoaded){
      loaded.removeLast();
    }

    return output;
  }

  Future<Pokemon> getPokemonAtIndex(int index) async { //returns a full Pokemon object, as specified in pokemon.dart
    final listIndex = loaded.indexWhere((element) => element.number==index+1);
    if (listIndex==-1){
      final db = await initDB();
      final result = await db.query('expanded_pokemon_test', where: 'Number = ?', whereArgs: [index+1]);
      
      //Turn result into Pokemon object, in case we want to perform operations on it down the line, like add it to saved teams
      Pokemon pkmnResult = Pokemon(index+1, result[0]['Name'] as String, [], [], [result[0]['Type1'] as String, result[0]['Type2'] as String],
                                  [result[0]['HP'] as int, result[0]['Attack'] as int, result[0]['Defense'] as int, 
                                  result[0]['SP.Attack'] as int, result[0]['SP.Defense'] as int, result[0]['Speed'] as int]);
      loaded.add(pkmnResult);
      return pkmnResult;
    }
    else{
      return loaded[listIndex];
    }
  }
}