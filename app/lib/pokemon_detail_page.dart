import 'package:flutter/material.dart';

class PokemonDetailPage extends StatelessWidget {
  final Map<String, dynamic> pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon["Name"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Number: #${pokemon["Number"]}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Type 1: ${pokemon["Type1"]}"),
            Text("Type 2: ${pokemon["Type2"] ?? "None"}"),
            const SizedBox(height: 10),
            Text("HP: ${pokemon["HP"]}"),
            Text("Attack: ${pokemon["Attack"]}"),
            Text("Defense: ${pokemon["Defense"]}"),
            Text("Sp. Attack: ${pokemon["SpAttack"]}"),
            Text("Sp. Defense: ${pokemon["SpDefense"]}"),
            Text("Speed: ${pokemon["Speed"]}"),
          ],
        ),
      ),
    );
  }
}
