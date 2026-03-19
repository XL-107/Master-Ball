import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class DatabaseAccess{
  //vars
  late Database _db;
  final int loadedAtOnce = 50; //the minimum number of simultaneously loaded entries
  late List<Map<String, dynamic>> loaded;

  //init
  DatabaseAccess(){
    loaded = List<Map<String, dynamic>>.empty(growable: true);
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
    return _db.query('expanded_pokemon_test');
  }


  Future<String> getNameAtIndex(int index) async { //get only the name of a pokemon of a specified id
    final listIndex = loaded.indexWhere((element) => element['Number']==index+1);
    String output = "Not Found"; //Placeholder text doubles as error checking
    if (listIndex==-1){
      final db = await initDB();
      final result = await db.query('expanded_pokemon_test', where: 'Number = ?', whereArgs: [index+1]);
      loaded.add(result[0]);
      output = result[0]['Name'] as String; //if multiple results are returned (ie. mutliple forms) the first is selected
    }
    else{
      output = loaded[listIndex]['Name'] as String;
    }
    return output;
  }
}