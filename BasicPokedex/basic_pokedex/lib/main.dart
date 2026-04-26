import 'package:flutter/material.dart';
import 'package:grabber_sheet/grabber_sheet.dart';
import 'package:transparent_image/transparent_image.dart';
import 'pokemon.dart';
import 'detailedView.dart';
import 'dbaccess.dart';

void main() {
  //Initialize Flutter binding before accessing image cache
  WidgetsFlutterBinding.ensureInitialized();
  
  //Optimize image caching for performance
  imageCache.maximumSize = 100;
  imageCache.maximumSizeBytes = 50 * 1024 * 1024; //50 MB cache
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
  final ScrollController _controller = ScrollController();

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
        body: Stack(
          children: [
            if (currentPokemon != null)
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 110, 8, 185),
                ),
                child: DetailedView(pokemonEntry: currentPokemon!),
              ),
            if(currentPokemon == null) //when Currentpokemon is null uses containers to replicate grabbersheet look, but you can't drag grid down
              Column(
                children: [
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 30,
                    child: Center(
                      child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ),
                  ),
                  Expanded(
                    child: RawScrollbar(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.black,
                          width: 2.0, 
                        ),
                      ),
                      thumbColor: Color.fromARGB(255, 88, 125, 248),
                      thumbVisibility: true,
                      interactive: true,
                      controller: _controller,
                      thickness: 15.0,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        controller: _controller,
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
                                    image: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png',
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
                  ),
                ],
              ),
            if(currentPokemon != null)
              GrabberSheet( //makes gridView draggable to different heights in the screen (causes some annoying issues when on start or end of gridview)
                snap: true,
                initialChildSize: 0.65,
                minChildSize: 0.25,
                maxChildSize: 1.0,
                backgroundColor: Colors.black,
                borderRadius: BorderRadius.zero,
                snapSizes: [0.25, 0.65, 1.0],
                grabberStyle: GrabberStyle(
                  width: 20,
                  height: 20,
                  color: Colors.white,
                  radius: Radius.circular(10),
                  margin: EdgeInsetsGeometry.all(5)
                ),
                builder: (context, scrollController) {
                  return RawScrollbar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Colors.black,
                        width: 2.0, 
                      ),
                    ),
                    thumbColor: Color.fromARGB(255, 88, 125, 248),
                    thumbVisibility: true,
                    interactive: true,
                    controller: scrollController,
                    thickness: 15.0,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      controller: scrollController,
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
                                  image: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonNumber.png',
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
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}