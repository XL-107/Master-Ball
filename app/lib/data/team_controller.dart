import '../models/pokemon_model.dart';
import 'team_manager.dart';

class TeamController {
  final TeamManager _manager = TeamManager();

  List<Pokemon> get team => _manager.team;

  bool add(Pokemon pokemon) {
    return _manager.addPokemon(pokemon);
  }

  void remove(Pokemon pokemon) {
    _manager.removePokemon(pokemon);
  }

  void clear() {
    _manager.clearTeam();
  }

  bool isFull() {
    return _manager.teamSize >= 6;
  }
}