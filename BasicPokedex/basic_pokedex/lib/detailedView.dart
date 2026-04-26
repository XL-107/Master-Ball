import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'pokemon.dart';

class DetailedView extends StatelessWidget {

  final Pokemon pokemonEntry;

  const DetailedView({
    super.key,
    required this.pokemonEntry,
  });

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Expanded(child:SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemonEntry.number}.png',
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                            fadeInDuration: Duration(milliseconds: 300),
                            fadeOutDuration: Duration(milliseconds: 100),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 150,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Stack(
                            children: [
                              Text(
                                pokemonEntry.getNameWithForm(),
                                style: TextStyle(
                                  fontFamily: 'PKMN RBYGSC',
                                  fontSize: 20,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                pokemonEntry.getNameWithForm(),
                                style: TextStyle(
                                  fontFamily: 'PKMN RBYGSC',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 80,
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: 'https://raw.githubusercontent.com/PokeAPI/sprites/refs/heads/master/sprites/types/generation-vi/x-y/${pokemonEntry.apiTypeMatch(0)}.png',
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.none,
                              fadeInDuration: Duration(milliseconds: 5),
                              fadeOutDuration: Duration(milliseconds: 5),
                            ),
                          ),
                          if(pokemonEntry.typing.length > 1 && pokemonEntry.typing[1] != "None")
                            SizedBox(
                              height: 40,
                              width: 80,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: 'https://raw.githubusercontent.com/PokeAPI/sprites/refs/heads/master/sprites/types/generation-vi/x-y/${pokemonEntry.apiTypeMatch(1)}.png',
                                fit: BoxFit.fitWidth,
                                filterQuality: FilterQuality.none,
                                fadeInDuration: Duration(milliseconds: 5),
                                fadeOutDuration: Duration(milliseconds: 5),
                              ),
                            ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Table(
                border: TableBorder.all(
                  width: 2.0
                ),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                        'Abilities',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PKMN RBYGSC',
                        ),
                        textAlign: TextAlign.center,
                        ),
                      )
                    ]
                  ),
                  ...pokemonEntry.getAbilitiesFormatted().map((ability) => TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          ability,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PKMN RBYGSC',
                          ),
                        ),
                      ),
                    ]
                  )),
                ],
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(25)
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: BoxBorder.fromLTRB(top: BorderSide(width: 2.0), left: BorderSide(width: 2.0), right: BorderSide(width: 2.0))
                ),
                child: Text(
                  'Base Stats',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PKMN RBYGSC',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Table(
                border: TableBorder.all(
                  width: 2.0
                ),
                children: pokemonEntry.getStatsWithNames().entries.map((entry) => TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PKMN RBYGSC',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PKMN RBYGSC',
                        ),
                      ),
                    ),
                  ]
                )).toList(),
              )
            ],
          ),
        ),),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.22,
        ),
      ]
    );
  }
}