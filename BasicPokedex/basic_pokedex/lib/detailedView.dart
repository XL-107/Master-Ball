import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'pokemon.dart';

class DetailedView extends StatelessWidget {

  final Pokemon pokemonEntry;
  // final bool expanded;

  const DetailedView({
    super.key,
    required this.pokemonEntry,
    // required this.expanded,
  });

  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        // if(expanded)

        // if(!expanded)
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
    );
  }
}