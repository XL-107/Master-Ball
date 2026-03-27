import 'package:flutter/material.dart';
import 'pokemon.dart';
// import 'pokeApiService.dart';

class DexEntry extends StatelessWidget {
  
  final Pokemon pokemonEntry;

  const DexEntry({
    super.key,
    required this.pokemonEntry,
  });

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(pokemonEntry.imageUrl),
          // Text('$pokemonEntry'),
        ],
      ),
    ); 
  }
}

// class _DexEntryState extends State<DexEntry> {
//   final _service = PokeApiService();
//   late Future<List<Pokemon>> _pokemonFuture;
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pokemonFuture = _service.fetchOriginal151(); //fetches og 151 pokemon on initilization
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Pokemon>>(
//       future: _pokemonFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator()); //loading circle while waiting for api
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}')); //if theres an error
//         }

//         final pokemonList = snapshot.data!; //unwraps future so pokemon list is accessible

//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.network(pokemonList[currentIndex].imageUrl),
//               Text('${pokemonList[currentIndex]}'),
//             ],
//           ),
//         ); 
//       },
//     );
//   }
// }