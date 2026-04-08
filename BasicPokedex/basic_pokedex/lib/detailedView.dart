import 'package:flutter/material.dart';
import 'pokemon.dart';

class DetailedView extends StatelessWidget {

  final Pokemon pokemonEntry;

  const DetailedView({
    super.key,
    required this.pokemonEntry,
  });

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Image.network(
              pokemonEntry.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          // Text(intTo(pokemonEntry.id)),
        ],
      ),
    ); 
  }
}