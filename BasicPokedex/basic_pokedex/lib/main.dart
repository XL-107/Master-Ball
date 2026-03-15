import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'pokeApiService.dart';

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
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _service.fetchOriginal151();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<Pokemon>>(
          future: _pokemonFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final pokemonList = snapshot.data!;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(pokemonList[currentIndex].imageUrl),
                  Text('${pokemonList[currentIndex]}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() { //previous button
                          currentIndex = (currentIndex - 1 + pokemonList.length) % pokemonList.length; //decrements index. mod so it can loop
                        }),
                        child: Text('Previous'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => setState(() { //next button
                          currentIndex = (currentIndex + 1) % pokemonList.length; //increments index. mod so it can loop
                        }),
                        child: Text('Next'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}