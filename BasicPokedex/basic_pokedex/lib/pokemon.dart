class Pokemon {
  int number;
  String name;
  String? form;
  List<String> abilities;
  List<Move> moves;
  List<String> typing;
  List<int> baseStats;

  Pokemon(this.number, this.name, this.form, this.abilities, this.moves, this.typing, this.baseStats);

  String getNameWithForm(){
    return name + ((form == null || form == "") ? "" : ": $form");
  }

  String apiTypeMatch(int index){
    String type = typing[index].toLowerCase();
    return switch(type){
      'normal' => '1',
      'fighting' => '2',
      'flying' => '3',
      'poison' => '4',
      'ground' => '5',
      'rock' => '6',
      'bug' => '7',
      'ghost' => '8',
      'steel' => '9',
      'fire' => '10',
      'water' => '11',
      'grass' => '12',
      'electric' => '13',
      'psychic' => '14',
      'ice' => '15',
      'dragon' => '16',
      'dark' => '17',
      'fairy' => '18',
      _ => 'unknown',
    };
  }

  Map<String, int> getStatsWithNames(){
    int total = 0;
    baseStats.forEach((stat) {
      total += stat;
    });
    
    return {
      "HP": baseStats[0],
      "Attack": baseStats[1],
      "Defense": baseStats[2],
      "Sp. Atk": baseStats[3],
      "Sp. Def": baseStats[4],
      "Speed": baseStats[5],
      "Total": total
    };
  }

  List<String> getAbilitiesFormatted(){
    List<String> abilitiesFormatted = [];

    for(int i = 0; i < abilities.length; ++i){
      if(abilities[i] == abilities.last){
        abilitiesFormatted.add('${abilities[i]} (hidden ability)');
      }else if(abilities[i] != 'None'){
        abilitiesFormatted.add(abilities[i]); 
      }
    }
    return abilitiesFormatted;
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
