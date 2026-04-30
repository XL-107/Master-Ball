import 'package:flutter/material.dart';
import 'pokemon.dart';

class SearchBarApp extends StatefulWidget {
  final SearchController controller;
  final List<PokemonListItem> pokemonList;
  final ValueChanged<int> onPokemonSelected;

  const SearchBarApp({
    super.key,
    required this.controller,
    required this.pokemonList,
    required this.onPokemonSelected,
  });

  //returns a list of suggestions for search anchor suggestions builder based of search input
  List<MapEntry<int, PokemonListItem>> suggestPokemon(String input, List<PokemonListItem> dex){ 
    if(input.isEmpty){ //checks if there is input
      return [];
    }
    int? id = int.tryParse(input); //checks for int input (search by pokemon id)
    if(id != null && id <= dex.length && id > 0){
      return [MapEntry(id - 1, dex[id - 1])];
    }
    List<MapEntry<int, PokemonListItem>> nameSuggestions = [];
    for(int i = 0; i < dex.length; ++i){ //returns all pokemon starting with first letter of input and containing input
      if(dex[i].getNameWithForm()[0].toLowerCase() == input[0] && dex[i].getNameWithForm().toLowerCase().contains(input)){
        nameSuggestions.add(MapEntry(i, dex[i]));
      }
    }
    return nameSuggestions;
  }

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: widget.controller,
            backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 110, 8, 185)),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            trailing: <Widget>[
            ],
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              //returns possible pokemon based on input
              final suggestions = widget.suggestPokemon(controller.text.toLowerCase(), widget.pokemonList); 
              return suggestions.map((entry) {
                final index = entry.key;
                final pokemon = entry.value;
                return ListTile(
                  title: Text(pokemon.getNameWithForm()),
                  onTap: () {
                    setState(() {
                      controller.closeView(pokemon.getNameWithForm());
                      widget.onPokemonSelected(index);
                    });
                  },
                );
              }).toList();
            },
      ),
    );
  }
}