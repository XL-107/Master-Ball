import 'package:flutter/material.dart';
import 'pokemon.dart';
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
  final _db = DatabaseAccess();
  Pokemon? currentPokemon;
  final int pokemonCount = 151;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pokedex')),
        body: Column(
          children: [
            if (currentPokemon != null)
              DetailedView(pokemonEntry: currentPokemon!),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: pokemonCount,
                itemBuilder: (context, index) {
                final pokemonNumber = index + 1;
                return GestureDetector(
                  onTap: () async {
                    final pokemon = await _db.getPokemonAtIndex(index);
                    setState(() {
                      currentPokemon = pokemon;
                    });
                  },
                  child: Stack(
                    children: [
                      Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png',
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Text(
                          pokemonNumber.toString().padLeft(4, '0'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}