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
  final int maxLoaded = 100; //the most that should be loaded in either direction of the current index
  late List<Pokemon> loaded;
  String sortMethod = "Number"; //keeps track of what the loaded variable is currently sorted by; it is pokemon ID by default
  static Database? _cachedDb; //singleton pattern to avoid reopening database
  static bool _viewCreated = false;

  //init
  DatabaseAccess(){
    loaded = List<Pokemon>.empty(growable: true);
  }

  //funcs
  Future<Database> initDB() async {
    // Return cached database if already initialized
    if (_cachedDb != null) {
      return _cachedDb!;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, "MBDB.db");

    // Check if DB already exists
    final exists = await File(dbPath).exists();

    if (!exists) {
      //Copy from assets onto machine's local files
      ByteData data = await rootBundle.load("assets/MasterBall.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    //open the database (we're only reading it, but readonly has to be false for creating table view)
    final db = await openDatabase(dbPath, readOnly: false);
    
    // Only create view once
    if (!_viewCreated) {
      await db.execute('DROP VIEW IF EXISTS pokemon_with_total');
      await db.execute('CREATE VIEW pokemon_with_total AS SELECT *, (HP + Attack + Defense + "SP.Attack" + "SP.Defense" + Speed) AS Total FROM expanded_pokemon_test');
      _viewCreated = true;
    }
    
    _cachedDb = db;
    return db;
  }

  Future<List<Map<String, dynamic>>> getPokemon() async { //get all data for all pokemon
    final db = await initDB();
    return db.query('expanded_pokemon_test');
  }

  Future<String> getNameAtIndex(int index) async { //get only the name of a pokemon of a specified id
    if (sortMethod!="Number"){
      loaded = List<Pokemon>.empty(growable: true);
      sortMethod = "Number";
    }
    final listIndex = loaded.indexWhere((element) => element.number==index+1);
    String output = "Not Found"; //Placeholder text doubles as error checking
    if (listIndex==-1){
      final db = await initDB();
      final result = await db.query('expanded_pokemon_test', where: 'Number = ?', whereArgs: [index+1]);
      
      //Turn result into Pokemon object, in case we want to perform operations on it down the line, like add it to saved teams
      Pokemon pkmnResult = Pokemon(index+1, result[0]['Name'] as String, result[0]['Form'] as String?, [], [], 
                                  [result[0]['Type1'] as String, result[0]['Type2']==null ? "None" : result[0]['Type2'] as String],
                                  [result[0]['HP'] as int, result[0]['Attack'] as int, result[0]['Defense'] as int, 
                                  result[0]['SP.Attack'] as int, result[0]['SP.Defense'] as int, result[0]['Speed'] as int]);

      //abilities are stored in a separate table in the same database, and must be queried separately
      final abilities = await db.query('pokemon_abilities', where: 'Number = ?', whereArgs: [index+1]);
      pkmnResult.abilities = [abilities[0]['Ability1'] as String, abilities[0]['Ability2'] as String? ?? "None", abilities[0]['Hidden'] as String? ?? "None"];
      
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
    if (sortMethod!="Number"){
      loaded = List<Pokemon>.empty(growable: true);
      sortMethod = "Number";
    }
    final listIndex = loaded.indexWhere((element) => element.number==index+1);
    Pokemon output;
    if (listIndex==-1){
      final db = await initDB();
      final result = await db.query('expanded_pokemon_test', where: 'Number = ?', whereArgs: [index+1]);
      
      //Turn result into Pokemon object, in case we want to perform operations on it down the line, like add it to saved teams
      Pokemon pkmnResult = Pokemon(index+1, result[0]['Name'] as String, result[0]['Form'] as String?, [], [], 
                                  [result[0]['Type1'] as String, result[0]['Type2']==null ? "None" : result[0]['Type2'] as String],
                                  [result[0]['HP'] as int, result[0]['Attack'] as int, result[0]['Defense'] as int, 
                                  result[0]['SP.Attack'] as int, result[0]['SP.Defense'] as int, result[0]['Speed'] as int]);
      
      final abilities = await db.query('pokemon_abilities', where: 'Number = ?', whereArgs: [index+1]);
      pkmnResult.abilities = [abilities[0]['Ability1'] as String, abilities[0]['Ability2'] as String? ?? "None", abilities[0]['Hidden'] as String? ?? "None"];
      
      loaded.add(pkmnResult);
      output = pkmnResult;
    }
    else{
      output = loaded[listIndex];
    }

    while (loaded[0].number < index-maxLoaded){
      loaded.removeAt(0);
    }
    while (loaded[loaded.length-1].number > index+maxLoaded){
      loaded.removeLast();
    }

    return output;
  }

  Future<Pokemon> getPokemonByStat(int index, String stat) async{ //return results sorted by the desired stat, use Total to sort by BST
    final db = await initDB();
    if (sortMethod!=stat){
      sortMethod=stat;
      loaded = List<Pokemon>.empty(growable: true);
    }

    if (loaded.length>index){
      return loaded[index]; //if loaded is sorted by stats, it will have everything from the first pokemon until the current, unlike when sorting by number
    }

    final result = await db.rawQuery('SELECT * FROM pokemon_with_total ORDER BY "$stat" DESC LIMIT ${index+1}');
    for (int i=loaded.length; i<=index; i++){
      final abilities = await db.query('pokemon_abilities', where: 'Number = ? AND (Form = ? OR (Form IS NULL AND ? IS NULL))', whereArgs: [result[i]['Number'], result[i]['Form'],  result[i]['Form']]);
      Pokemon pkmnResult = Pokemon(result[i]["Number"] as int, result[i]['Name'] as String, result[i]['Form'] as String?, 
                                  [abilities[0]['Ability1'] as String, abilities[0]['Ability2'] as String? ?? "None", abilities[0]['Hidden'] as String? ?? "None"], [],
                                  [result[i]['Type1'] as String, result[i]['Type2']==null ? "None" : result[i]['Type2'] as String],
                                  [result[i]['HP'] as int, result[i]['Attack'] as int, result[i]['Defense'] as int, 
                                  result[i]['SP.Attack'] as int, result[i]['SP.Defense'] as int, result[i]['Speed'] as int]);
            
      loaded.add(pkmnResult);
    }

    return loaded[loaded.length-1];
  }

  Future<List<PokemonListItem>> getPokemonList() async{ //returns a list of all pokemon in the database, but only with their number, name, and form, for use in the search function
    final db = await initDB();
    final result = await db.query('expanded_pokemon_test', columns: ['Number', 'Name', 'Form']);
    List<PokemonListItem> output = [];
    for (int i=0; i<result.length; i++){
      output.add(PokemonListItem(result[i]['Number'] as int, result[i]['Name'] as String, result[i]['Form'] as String?));
    }
    return output;
}