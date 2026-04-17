/*class Pokemon{
  final int id;
  final String name;
  final List<String> types;
  final 
  
  Pokemon({ //pokemon class constructor
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
  });

   factory Pokemon.fromJson(Map<String, dynamic> json) { //factory contructor parses json and uses regular constructor

    List<String> typeList = []; //loops through types in json to add to typeList array
    for(var t in json['types'] as List){
      typeList.add(t['type']['name'] as String);
    }

    return Pokemon( //passes json info to constructor
      id: json['id'],
      name: json['name'],
      types: typeList,
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? 
                json['sprites']['front_default'],
    );
  }

  

  @override
  String toString() {
    return 'ID: $id, Name: $name, Type(s): $types';
  }
}*/

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

  String get getName{
    return name;
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
