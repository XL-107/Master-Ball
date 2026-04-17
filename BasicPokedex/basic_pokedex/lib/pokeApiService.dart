// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'pokemon.dart';

// class PokeApiService {
//   static const String _baseUrl = 'https://pokeapi.co/api/v2';

//   Future<Pokemon> fetchPokemon(int id) async { //fetches a single pokemon from api
//     //rather than making many individual get requests should be replaced with a client to be more efficient
//     final response = await http.get(Uri.parse('$_baseUrl/pokemon/$id')); 

//     if (response.statusCode == 200) { //fetch successful
//       return Pokemon.fromJson(jsonDecode(response.body));
//     } else { //fetch unsuccessful
//       throw Exception('Failed to load Pokémon #$id');
//     }
//   }

//   Future<List<Pokemon>> fetchOriginal151() async { //fetches original 151 pokemon
//     final List<Future<Pokemon>> futures = [];
//     for (int i = 1; i <= 151; i++) { //loops through og 151 parsed from json
//       futures.add(fetchPokemon(i));
//     }
//     return await Future.wait(futures); //waits to return until all have loaded
//   }
// }