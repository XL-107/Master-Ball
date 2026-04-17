import 'package:flutter/material.dart';
import 'pokemon.dart';

class DexEntry extends StatelessWidget {
  
  final Pokemon pokemonEntry;

  const DexEntry({
    super.key,
    required this.pokemonEntry,
  });

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 177, 67, 240),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              )
            ),
            child: Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemonEntry.number}.png',
              fit: BoxFit.contain,
            ),
          ),
          // Text(intTo(pokemonEntry.id)),
        ],
      ),
    ); 
  }
}