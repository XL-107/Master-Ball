import '../models/pokemon_model.dart';

class TeamManager {
  final List<Pokemon> _team = [];

  List<Pokemon> get team => _team;

  bool addPokemon(Pokemon pokemon) {
    if (_team.length >= 6) return false;
    _team.add(pokemon);
    return true;
  }

  void removePokemon(Pokemon pokemon) {
    _team.remove(pokemon);
  }

  void clearTeam() {
    _team.clear();
  }

  int get teamSize => _team.length;
}