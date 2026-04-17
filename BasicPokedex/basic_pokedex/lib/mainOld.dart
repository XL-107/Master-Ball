/*import 'package:basic_pokedex/dexEntry.dart';
import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'pokeApiService.dart';
import 'detailedView.dart';
import 'dbaccess.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _service = PokeApiService();
  late Future<List<Pokemon>> _pokemonFuture;
  Pokemon? currentPokemon;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _service.fetchOriginal151(); //fetches og 151 pokemon on initilization
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pokedex')),
        body: FutureBuilder<List<Pokemon>>(
          future: _pokemonFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); //loading circle while waiting for api
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); //if theres an error
            }

            final pokemonList = snapshot.data!; //unwraps future so pokemon list is accessible
            
            List<GestureDetector> dexList = [];
            for(int i = 0; i < pokemonList.length; ++i){ //turns each pokemon into a dexEntry widget so it can be used in gridView
              dexList.add(
                GestureDetector(
                  onTap: (){
                    setState((){
                      currentPokemon = pokemonList[i];
                    });
                  },
                  child: DexEntry(pokemonEntry: pokemonList[i]),
                ),
              );
            }

            return Column(
              children: [
                if(currentPokemon != null)
                  DetailedView(pokemonEntry: currentPokemon!),
                Expanded(
                  child: 
                    GridView.count(
                      crossAxisCount: 5, //number of columns
                      children: dexList,
                    ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}*/