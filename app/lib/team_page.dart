import 'package:flutter/material.dart';
import 'models/pokemon_model.dart';

class TeamPage extends StatelessWidget {
  final List<Pokemon> team;

  const TeamPage({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Team")),
      body: team.isEmpty
          ? const Center(child: Text("No Pokémon in team yet"))
          : ListView.builder(
              itemCount: team.length,
              itemBuilder: (context, index) {
                final p = team[index];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text("#${p.number} • ${p.type1}"
                      "${p.type2 != null ? " / ${p.type2}" : ""}"),
                );
              },
            ),
    );
  }
}