class Pokemon {
  int number;
  String name;
  String? form;
  List<String> abilities;
  List<Move> moves;
  List<String> typing;
  List<int> baseStats;
  //Image for pokemon

  Pokemon(this.number, this.name, this.form, this.abilities, this.moves, this.typing, this.baseStats);

  String getNameWithForm(){
    return name + ((form == null || form == "") ? "" : ": $form");
  }
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

