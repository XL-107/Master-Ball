import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
var typeNames = [
  'Normal','Fire','Water','Electric','Grass','Ice',
  'Fighting','Poison','Ground','Flying','Psychic',
  'Bug','Rock','Ghost','Dragon','Dark','Steel','Fairy'
];
Future<Database> initDatabaseType() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'type_chart.db');

  // Check if DB already exists
  final exists = await databaseExists(path);

  if (exists) {
    await deleteDatabase(path);
  }

  print("Copying database from assets...");

  ByteData data = await rootBundle.load('assets/type_chart.db');
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  await File(path).writeAsBytes(bytes, flush: true);

  return openDatabase(path);
}
Future<Database> initDatabasePokemon() async{
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'expanded_pokemon_test.db');

  // Check if DB already exists
  final exists = await databaseExists(path);

  if (exists) {
    await deleteDatabase(path);
  }

  print("Copying database from assets...");

  ByteData data = await rootBundle.load('assets/expanded_pokemon_test.db');
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  await File(path).writeAsBytes(bytes, flush: true);

  return openDatabase(path);
}
//Function that returns all of the types from type_chart.db into the Type class
Future<List<Type>> types() async {
  final db = await initDatabaseType();
  final List<Map<String, Object?>> typeMaps = await db.query("type_chart");
  return [for (final map in typeMaps) Type.fromMap(map),];
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TeambuilderMenu());
}
//class used to represent each type's defensive matchups in the form of a map. Key represents the offensive type going against
//it and its value represents that type's matchup against the offensive type.
class Type{
  final String type;
  final List<double> typeMatchups;
  Type({required this.type, required this.typeMatchups});
  Map<String, Object?> toMap() {
    return {'Type': type, 
    'Normal': typeMatchups[0], 
    'Fire': typeMatchups[1],
    'Water': typeMatchups[2],
    'Electric': typeMatchups[3],
    'Grass': typeMatchups[4],
    'Ice': typeMatchups[5],
    'Fighting': typeMatchups[6],
    'Poison': typeMatchups[7],
    'Ground': typeMatchups[8],
    'Flying': typeMatchups[9],
    'Psychic': typeMatchups[10],
    'Bug': typeMatchups[11],
    'Rock': typeMatchups[12],
    'Ghost': typeMatchups[13],
    'Dragon': typeMatchups[14],
    'Dark': typeMatchups[15],
    'Steel': typeMatchups[16],
    'Fairy': typeMatchups[17]};
  }
  factory Type.fromMap(Map<String, Object?> map) {
    return Type(
      type: map['Type'] as String,
      typeMatchups: [
        (map['Normal'] as num).toDouble(),
        (map['Fire'] as num).toDouble(),
        (map['Water'] as num).toDouble(),
        (map['Electric'] as num).toDouble(),
        (map['Grass'] as num).toDouble(),
        (map['Ice'] as num).toDouble(),
        (map['Fighting'] as num).toDouble(),
        (map['Poison'] as num).toDouble(),
        (map['Ground'] as num).toDouble(),
        (map['Flying'] as num).toDouble(),
        (map['Psychic'] as num).toDouble(),
        (map['Bug'] as num).toDouble(),
        (map['Rock'] as num).toDouble(),
        (map['Ghost'] as num).toDouble(),
        (map['Dragon'] as num).toDouble(),
        (map['Dark'] as num).toDouble(),
        (map['Steel'] as num).toDouble(),
        (map['Fairy'] as num).toDouble(),
      ],
    );
  }
}
//Class that represents a Pokemon's individual data from the 
class Pokemon {
  final int id;
  final String name;
  final String type1;
  final String type2;
  Pokemon({
    required this.id, 
    required this.name, 
    required this.type1, 
    required this.type2
  });
  factory Pokemon.fromMap(Map<String, dynamic> map){
    return Pokemon(
      id: map['Number'],
      name: map['Name'],
      type1: map['Type1'],
      type2: map['Type2'] ?? 'None',
    );
  }
}
//Helper function that calculates the type matchup for an individual Pokemon against a singular offensive type. It will always
//find the defensive matchup for a Pokemon's primary type but if it does have one more type, it will multiply the secondary type's
//defensive matchup with the offensive type's.
double getDefMatchup(String primary, String secondary, String offense, List<Type> allTypes){
  final offensiveType = allTypes.firstWhere(
    (t) => t.type == offense,
  );
  final primaryType = allTypes.firstWhere(
    (t) => t.type == primary,
  );
  int attackIndex = typeNames.indexOf(offensiveType.type);
  double multiplier = primaryType.typeMatchups[attackIndex];
  if (secondary != 'None'){
    final secondaryType = allTypes.firstWhere(
      (t) => t.type == secondary,
    );
    multiplier *= secondaryType.typeMatchups[attackIndex];
  }
  return multiplier;
}
//Helper function that gets a Pokemon's typing
Future<Pokemon?> getPokemon(String pokemonName) async {
  final db = await initDatabasePokemon();
  final List<Map<String, dynamic>> result = await db.query(
    'expanded_pokemon_test',
    columns: ['Number', 'Name', 'Type1', 'Type2'],
    where: 'Name = ?',
    whereArgs: [pokemonName],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return Pokemon.fromMap(result.first);
  } else {
    print("Pokemon not found");
    return null;
  }
}
//TeambuilderMenu widget. Generates the content on the page.
class TeambuilderMenu extends StatefulWidget{
  @override
  State<TeambuilderMenu> createState() => TeambuilderMenuState();
}
class TeambuilderMenuState extends State<TeambuilderMenu> {
  List<Type> allTypes = [];
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  List<String> pokemonNames = [];
  Map<String, Pokemon> pokemonMap = {};
  String getTypeAsset(String type) {
    return 'assets/type_logos/$type.png';
  }
  String getPokemonImage(int dexNum) {
    //'https://play.pokemonshowdown.com/sprites/gen5/${pokemon}.png'
    /*String dex = dexNum.toString();
    if (dexNum < 10) {
      dex = '000$dex';
    }else if (dexNum < 100) {
      dex = '00$dex';
    }else if (dexNum < 1000) {
      dex = '0$dex';
    }
    return 'https://raw.githubusercontent.com/PMDCollab/SpriteCollab/master/portrait/$dex/Normal.png';*/
    return 'assets/icons/icon_$dexNum.png';
  }
  String showdownFormatting(String pokemon) {
    return pokemon.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
  Future<void> loadPokemon() async {
    for (var name in pokemonNames) {
      final p = await getPokemon(name);
      if (p != null) {
        pokemonMap[name] = p;
      }
    }
    setState(() {});
  }
  void updateTeam() async {
    pokemonNames = controllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    pokemonMap.clear();

    await loadPokemon();
  }

  @override
  void initState() {
    super.initState();
    loadTypes();
    loadPokemon();
    print(pokemonMap);
  }

  void loadTypes() async {
    final data = await types();
    setState(() {
      allTypes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
      Map<String, int> totalWeaks = {
      'Normal': 0,
      'Fire': 0,
      'Water': 0,
      'Electric': 0,
      'Grass': 0,
      'Ice': 0,
      'Fighting': 0,
      'Poison': 0,
      'Ground': 0,
      'Flying': 0,
      'Psychic': 0,
      'Bug': 0,
      'Rock': 0,
      'Ghost': 0,
      'Dragon': 0,
      'Dark': 0,
      'Steel': 0,
      'Fairy': 0,
    };
    Map<String, int> totalResists = {
      'Normal': 0,
      'Fire': 0,
      'Water': 0,
      'Electric': 0,
      'Grass': 0,
      'Ice': 0,
      'Fighting': 0,
      'Poison': 0,
      'Ground': 0,
      'Flying': 0,
      'Psychic': 0,
      'Bug': 0,
      'Rock': 0,
      'Ghost': 0,
      'Dragon': 0,
      'Dark': 0,
      'Steel': 0,
      'Fairy': 0,
    };
    return MaterialApp(
      // MaterialApp with debugShowCheckedModeBanner false and home
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        // Scaffold with appbar ans body.
        backgroundColor: Colors.purple,
        appBar: AppBar(
          title: Text('Pokemon Type Chart'),
        ),
        body: Column(
          children: [
            Wrap(
              spacing: 10,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 120,
                  child: TextField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Pokemon ${index + 1}',
                    ),
                  ),
                );
              }),
            ),

            ElevatedButton(
              onPressed: () {
                updateTeam();
              },
              child: Text('Build Team'),
            ),
            Expanded(
              child: pokemonNames.isEmpty ? const Center(
                child: Text(
                  "Enter a team",
                  style: TextStyle(fontSize: 18),
                ),
                )
                : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                        border: TableBorder.all(
                          width: 1.0,
                          color: Colors.black,
                        ),
                        columns: const [
                          DataColumn(label: Text('Type')),
                        ],
                        rows: typeNames.map((type) {
                          return DataRow(
                            cells: [
                              DataCell(Image.asset(
                                getTypeAsset(type),
                                width: 32,
                                height: 32,
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            border: TableBorder.all(
                              width: 1.0,
                              color: Colors.black,
                            ),
                            columns: [
                              ...pokemonNames.map((name) {
                                final pokemon = pokemonMap[name];
                                return DataColumn(
                                  label:
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: pokemon != null ? Image.asset(
                                        getPokemonImage(pokemon.id),
                                        width: 60,
                                        height: 60,
                                      )
                                      : const SizedBox(width: 60, height: 60),
                                    ),
                                  ) 
                                   // fallback UI
                                );
                              }),
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:Center(child: Text('Total Weaks')),
                                )
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:Center(child: Text('Total Resists')),
                                )
                              ),
                            ],

                            rows: typeNames.map((type) {
                              return DataRow(
                                cells: [
                                  ...pokemonNames.map((name) {
                                    final pokemon = pokemonMap[name];
                                    if (pokemon == null) {
                                      return const DataCell(Text('N/A'));
                                    }
                                    final matchup = getDefMatchup(pokemon.type1, pokemon.type2, type, allTypes);
                                    if (matchup < 1.0) {
                                      totalResists[type] = (totalResists[type] ?? 0) + 1;
                                    }else if (matchup > 1.0){
                                      totalWeaks[type] = (totalWeaks[type] ?? 0) + 1;
                                    }
                                    return DataCell(
                                      SizedBox(
                                        width: 32,
                                        child: Center(
                                          child: Text(matchup.toString()),
                                        )
                                      )
                                    );
                                  }),
                                  DataCell(
                                    SizedBox(
                                      width: 64,
                                      child: Center(
                                        child: Text(totalWeaks[type].toString()),
                                      )
                                    )
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 64,
                                      child: Center(
                                        child: Text(totalResists[type].toString()),
                                      )
                                    )
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
      )
    );
  }
}
