class Pokemon {
  final int entryId;
  final int number;
  final String name;
  final String? form;
  final String type1;
  final String? type2;
  final int hp;
  final int attack;
  final int defense;
  final int spAttack;
  final int spDefense;
  final int speed;

  Pokemon({
    required this.entryId,
    required this.number,
    required this.name,
    this.form,
    required this.type1,
    this.type2,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.spAttack,
    required this.spDefense,
    required this.speed,
  });

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      entryId: map['EntryId'],
      number: map['Number'],
      name: map['Name'],
      form: map['Form'],
      type1: map['Type1'],
      type2: map['Type2'],
      hp: map['HP'],
      attack: map['Attack'],
      defense: map['Defense'],
      spAttack: map['SpAttack'],
      spDefense: map['SpDefense'],
      speed: map['Speed'],
    );
  }
}