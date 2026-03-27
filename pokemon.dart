class Pokemon {
  String name;
  List<Ability> abilities;
  List<Move> moves;
  List<String> typing;
  List<int> baseStats;
  //Image for pokemon

  Pokemon(this.name, this.abilities, this.moves, this.typing, this.baseStats);


}

class Ability {
  String name;
  String description;
  bool isHidden;

  Ability(this.name, this.description, this.isHidden);
}

class Move {
  String name;
  String description;
  int power;
  int accuracy;
  String catagory;
  String type;

  Move(this.name, this.description, this.power, this.accuracy, this.catagory, this.type);
}

