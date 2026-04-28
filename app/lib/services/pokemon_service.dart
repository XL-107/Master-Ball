import '../data/pokemon_repository.dart';
import '../models/pokemon_model.dart';

class PokemonService {
  final PokemonRepository _repo = PokemonRepository();

  Future<List<Pokemon>> search(String query) async {
    final results = await _repo.searchByName(query);
    return results.map((p) => Pokemon.fromMap(p)).toList();
  }

  Future<List<Pokemon>> filterByType(String type) async {
    final results = await _repo.filterByType(type);
    return results.map((p) => Pokemon.fromMap(p)).toList();
  }

  Future<List<Pokemon>> sortByTotal() async {
    final results = await _repo.sortByTotal();
    return results.map((p) => Pokemon.fromMap(p)).toList();
  }
}