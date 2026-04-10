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

  @override
  void initState() {
    super.initState();
    loadPokemon();
  }

  Future<void> loadPokemon() async {
    final results = await repo.searchByName("Char");
    setState(() {
      pokemon = results;
    });
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
              final results = await repo.searchByName(value);
              setState(() {
                pokemon = results;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pokemon.length,
            itemBuilder: (context, index) {
              final p = pokemon[index];
              return ListTile(
                title: Text(p["Name"]),
                subtitle: Text("#${p["Number"]}"),
              );
            },
          ),
        ),
      ],
    ),
  );
}
