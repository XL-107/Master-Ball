import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(pokemon.name),
        subtitle: Text("#${pokemon.number} • ${pokemon.type1}"
            "${pokemon.type2 != null ? " / ${pokemon.type2}" : ""}"),
        onTap: onTap,
      ),
    );
  }
}