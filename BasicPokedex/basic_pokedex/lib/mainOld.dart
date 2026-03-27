// import 'package:flutter/material.dart';
// import 'pokemon.dart';
// import 'pokeApiService.dart';
// import 'searchBar.dart';

// void main() {
//   runApp(MainApp());
// }

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   final _service = PokeApiService();
//   final _searchController = SearchController();
//   late Future<List<Pokemon>> _pokemonFuture;
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pokemonFuture = _service.fetchOriginal151(); //fetches og 151 pokemon on initilization
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Pokedex')),
//         body: FutureBuilder<List<Pokemon>>(
//           future: _pokemonFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator()); //loading circle while waiting for api
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}')); //if theres an error
//             }

//             final pokemonList = snapshot.data!; //unwraps future so pokemon list is accessible

//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SearchBarApp(
//                     controller: _searchController,
//                     pokemonList: pokemonList,
//                     onPokemonSelected: (index) => setState(() => currentIndex = index),
//                   ),
//                   Image.network(pokemonList[currentIndex].imageUrl),
//                   Text('${pokemonList[currentIndex]}'),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => setState(() { //previous button
//                           currentIndex = (currentIndex - 1 + pokemonList.length) % pokemonList.length; //decrements index. mod so it can loop
//                         }),
//                         child: Text('Previous'),
//                       ),
//                       SizedBox(width: 16),
//                       ElevatedButton(
//                         onPressed: () => setState(() { //next button
//                           currentIndex = (currentIndex + 1) % pokemonList.length; //increments index. mod so it can loop
//                         }),
//                         child: Text('Next'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ); 
//           },
//         ),
        
//       ),
//     );
//   }
// }