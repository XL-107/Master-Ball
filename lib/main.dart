import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  
  runApp(const MainApp());
}

class PokemonBasic{ //just name and types, no other data (for now)
  final int ID;
  final String Name;
  final String Type1;
  final String? Type2;

  const PokemonBasic({required this.ID, required this.Name, required this.Type1, required this.Type2});

  String getName(){
    return Name;
  }
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<PokemonBasic?> queryIndex(int index) async { //returns only a single pokemon at a time
    final database = openDatabase(join(await getDatabasesPath(), 'pokemon_text.sql')); //set path to database and store reference
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query("pokemon_test", where: 'ID = ?', whereArgs: [index]);

    if (maps.isNotEmpty){ //return pokemon info, but only id, name, type1, and type2
      return PokemonBasic(ID: maps.first["ID"] as int, Name: maps.first["Name"] as String, Type1: maps.first["Type1"] as String, Type2: maps.first["Type2"] as String);
    }
    return null; //in case index is invalid
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.purpleAccent, title: Text('Pokedex')),
        body: ListView.builder(
          itemCount: 1025,
          itemBuilder:(BuildContext context, int index) {
            return FutureBuilder<PokemonBasic?>(
              future: queryIndex(index),
              builder: (context, snapshot) {
              
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 50,
                    child: Text("..."), //data has yet to load
                  );
                }

                //Error checking
                if (!snapshot.hasData || snapshot.data == null) {
                  return Container(
                    height: 50,
                    child: Text("ERROR"),
                  );
                }

                final pokemon = snapshot.data!; //idk what this actually does, i got it from chatgpt (TODO: figure out what snapshots are)
              
                return Container(
                  height: 50,
                  child: Text(pokemon.Name)
                );

              }
            );
            
          }
        )
      ),
    );
  }
}
