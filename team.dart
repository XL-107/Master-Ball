import 'pokemon.dart';

class Team {
  String name;
  List<Pokemon> members;

  Team(this.name, this.members);

  void addPokemon(Pokemon p){
    members.add(p);
  }

}

