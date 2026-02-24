import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final List<Pokemon> pokemonList = [ //list with first 3 pokemon. Needs to be changed to be implemented with database
    Pokemon('Bulbasaur', 'Stage 1', 'assets/001.png'),
    Pokemon('Ivysaur', 'Stage 2', 'assets/002.png'),
    Pokemon('Venasaur', 'Stage 3', 'assets/003.png'),
  ];

  int currentIndex = 0;

  void next() { //increments index to show next pokemon in dex array
    setState(() {
      currentIndex = (currentIndex + 1) % pokemonList.length;
    });
  }

  void previous() { //decrements index to show next pokemon in dex array
    setState(() {
      currentIndex = (currentIndex - 1 + pokemonList.length) % pokemonList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(pokemonList[currentIndex].imagePath), //displays image
              Text('${pokemonList[currentIndex]}'), //prints text from pokemon toString function
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ //previous and next buttons. Should be replaced/shared with swipes to prioritize for mobile
                  ElevatedButton(onPressed: previous, child: Text('Previous')),
                  SizedBox(width: 16),
                  ElevatedButton(onPressed: next, child: Text('Next')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Pokemon{
  String name;
  String stage;
  String imagePath;
  //need to add whatever other info we want to display

  Pokemon(this.name, this.stage, this.imagePath);

  @override
  String toString() {
    return 'Pokemon(name: $name, stage: $stage)';
  }
}