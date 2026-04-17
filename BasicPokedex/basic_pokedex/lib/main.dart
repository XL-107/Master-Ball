import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'pokemon.dart';
import 'detailedView.dart';
import 'dbaccess.dart';

void main() {
  // Initialize Flutter binding before accessing image cache
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optimize image caching for performance
  imageCache.maximumSize = 100;
  imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50 MB cache
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
  final int pokemonCount = 1025;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Stack(
            children: [
              Text(
                'Pokedex',
                style: TextStyle(
                  fontFamily: 'PKMN RBYGSC',
                  fontSize: 30,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Colors.black,
                ),
              ),
              Text(
                'Pokedex',
                style: TextStyle(
                  fontFamily: 'PKMN RBYGSC',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 110, 8, 185),
        ),
        body: Column(
          children: [
            if (currentPokemon != null)
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 110, 8, 185),
                ),
                child: DetailedView(pokemonEntry: currentPokemon!),
              ),
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
                      if(currentPokemon != pokemon){
                        currentPokemon = pokemon;
                      }else{
                        currentPokemon = null;
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 177, 67, 240),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          )
                        ),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemonNumber}.png',
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 100),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Text(
                          pokemonNumber.toString().padLeft(4, '0'),
                          style: TextStyle(
                            fontFamily: 'PKMN RBYGSC',
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