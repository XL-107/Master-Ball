import 'pokemon.dart';
import 'dart:convert';

class Team {
  String name;
  List<Pokemon> members;

  Team({required this.name, required this.members});

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    name : json['name'],
    members: json['members'],
    );

  Map<String, dynamic> toJson() => {
    'name': name,
    'members': members,
  };
  

  void addPokemon(Pokemon p){
    members.add(p);
  }

  void removePokemon(int index){
    members.removeAt(index);
  }

}

