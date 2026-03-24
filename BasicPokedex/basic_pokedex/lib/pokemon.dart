class Pokemon{
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  
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

  String get getName{
    return name;
  }

  @override
  String toString() {
    return 'ID: $id, Name: $name, Type(s): $types';
  }
}