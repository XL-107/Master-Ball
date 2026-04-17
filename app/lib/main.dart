import 'pokemon_detail_page.dart';

import 'package:flutter/material.dart';
import 'data/pokemon_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PokemonListPage(),
    );
  }
}

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final repo = PokemonRepository();
  List<Map<String, dynamic>> pokemon = [];
  String selectedType = "All";
  String selectedSort = "None";

  @override
  void initState() {
    super.initState();
    loadPokemon();
  }

  Future<void> loadPokemon() async {
    final results = await repo.searchByName("");
    setState(() {
      pokemon = results;
    });
  }

  Future<void> searchPokemon(String value) async {
    final results = await repo.searchByName(value);
    setState(() {
      pokemon = results;
    });
  }

  Future<void> filterPokemonByType(String type) async {
    if (type == "All") {
      final results = await repo.searchByName("");
      setState(() {
        pokemon = results;
      });
    } else {
      final results = await repo.filterByType(type);
      setState(() {
        pokemon = results;
      });
    }
  }

  Future<void> sortPokemon(String sortType) async {
    if (sortType == "Total") {
      final results = await repo.sortByTotal();
      setState(() {
        pokemon = results;
      });
    } else {
      final results = await repo.searchByName("");
      setState(() {
        pokemon = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokemon Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search Pokemon",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) async {
                selectedSort = "None";
                await searchPokemon(value);
              },
            ),
          ),
          DropdownButton<String>(
            value: selectedType,
            items: [
              "All",
              "Fire",
              "Water",
              "Grass",
              "Electric",
              "Psychic",
              "Ice",
              "Dragon",
            ].map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) async {
              if (value == null) return;

              setState(() {
                selectedType = value;
                selectedSort = "None";
              });

              await filterPokemonByType(value);
            },
          ),
          DropdownButton<String>(
            value: selectedSort,
            items: [
              "None",
              "Total",
            ].map((sort) {
              return DropdownMenuItem<String>(
                value: sort,
                child: Text("Sort: $sort"),
              );
            }).toList(),
            onChanged: (value) async {
              if (value == null) return;

              setState(() {
                selectedSort = value;
              });

              await sortPokemon(value);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pokemon.length,
              itemBuilder: (context, index) {
                final p = pokemon[index];
                return ListTile(
                  title: Text(p["Name"]),
                  subtitle: Text("#${p["Number"]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailPage(pokemon: p),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}