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
Map<String, List<String>> immuneAbilities = {
  'Dry Skin': ['Water'],
  'Earth Eater': ['Ground'],
  'Flash Fire': ['Fire'],
  'Levitate': ['Ground'],
  'Lightning Rod': ['Electric'],
  'Sap Sipper': ['Grass'],
  'Storm Drain': ['Water'],
  'Volt Absorb': ['Electric'],
  'Water Absorb': ['Water'],
  'Wonder Guard': [
    'Poison', 
    'Ground', 
    'Bug', 
    'Steel', 
    'Water',
    'Grass',
    'Electric',
    'Psychic',
    'Ice',
    'Dragon',
    'Fairy'
  ]
};
Future<Database> initDatabaseType() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'type_chart.db');

  // Check if DB already exists
  final exists = await databaseExists(path);

  if (!exists) {
    final data = await rootBundle.load('assets/type_chart.db');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes, flush: true);
  }

  return openDatabase(path);
}
Future<Database> initDatabasePokemon() async{
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'expanded_pokemon_test.db');

  // Check if DB already exists
  final exists = await databaseExists(path);

  if (!exists) {
    final data = await rootBundle.load('assets/expanded_pokemon_test.db');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes, flush: true);
  }

  return openDatabase(path);
}
Future<Database> initDatabaseAbilities() async{
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'pokemon_abilities.db');

  // Check if DB already exists
  final exists = await databaseExists(path);

  if (!exists) {
    final data = await rootBundle.load('assets/pokemon_abilities.db');
    final bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes, flush: true);
  }

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
//Class that represents a Pokemon's individual data from the pokemon abilities database. 
class Pokemon {
  final int id;
  final String name;
  final String? form;
  final String type1;
  final String type2;
  final String ability1;
  final String ability2;
  final String abilityH;
  Pokemon({
    required this.id, 
    required this.name,
    required this.form,
    required this.type1, 
    required this.type2,
    required this.ability1,
    required this.ability2,
    required this.abilityH
  });
  factory Pokemon.fromMap(Map<String, dynamic> map){
    return Pokemon(
      id: map['Number'],
      name: map['Name'],
      form: map['Form'] ?? 'None',
      type1: map['Type1'],
      type2: map['Type2'] ?? 'None',
      ability1: map['Ability1'] ?? 'None',
      ability2: map['Ability2'] ?? 'None',
      abilityH: map['Hidden'] ?? 'None',
    );
  }
}
//Helper function that calculates the type matchup for an individual Pokemon against a singular offensive type. It will always
//find the defensive matchup for a Pokemon's primary type but if it does have one more type, it will multiply the secondary type's
//defensive matchup with the offensive type's.
double getDefMatchup(String primary, String secondary, String? ability, String offense, List<Type> allTypes){
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
  if (immuneAbilities[ability]?.contains(offense) ?? false) {
    return 0.0;
  }
  return multiplier;
}
//Takes the Pokemon's name and form (if specified) and returns the Pokemon class version that has all of its information
Future<Pokemon?> getPokemon(String pokemonName, {String? form}) async {
  final pokemonDb = await initDatabasePokemon();
  final abilityDb = await initDatabaseAbilities();

  // normalize form
  final normalizedForm = (form == null || form == '') ? null : form;

  final pokemonResult = await pokemonDb.query(
    'expanded_pokemon_test',
    where: normalizedForm == null
        ? 'Name = ? AND Form IS NULL'
        : 'Name = ? AND Form = ?',
    whereArgs: normalizedForm == null
        ? [pokemonName]
        : [pokemonName, normalizedForm],
    limit: 1,
  );

  if (pokemonResult.isEmpty) {
    return null;
  }

  final base = pokemonResult.first;

  final abilityResult = await abilityDb.query(
    'pokemon_abilities',
    where: normalizedForm == null
        ? 'Name = ? AND FORM IS NULL'
        : 'Name = ? AND Form = ?',
    whereArgs: normalizedForm == null
        ? [pokemonName]
        : [pokemonName, normalizedForm],
    limit: 1,
  );

  final abilityRow = abilityResult.isNotEmpty ? abilityResult.first : null;

  //Combine into ONE Pokemon object
  return Pokemon(
    id: base['Number'] as int,
    name: base['Name'] as String,
    form: (base['Form'] ?? 'None') as String,
    type1: base['Type1'] as String,
    type2: (base['Type2'] ?? 'None') as String,
    ability1: (abilityRow?['Ability1'] ?? 'None') as String,
    ability2: (abilityRow?['Ability2'] ?? 'None') as String,
    abilityH: (abilityRow?['Hidden'] ?? 'None') as String,
  );
}
Future<List<String>> getForms(String pokemonName) async {
  final db = await initDatabasePokemon();

  final result = await db.query(
    'expanded_pokemon_test',
    columns: ['Form'],
    where: 'Name = ?',
    whereArgs: [pokemonName],
  );

  final formSet = result.map((row) {
    final form = row['Form'] as String?;
    return form ?? 'None';
  }).toSet();

  final forms = formSet.toList();

  forms.sort((a, b) {
    if (a == 'None') return -1;
    if (b == 'None') return 1;
    return a.compareTo(b);
  });

  return forms;
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
  List<String?> selectedForms = List.filled(6, null);
  List<String?> selectedAbilities = List.filled(6, null);

  List<List<String>> availableForms = List.generate(6, (_) => []);
  List<List<String>> availableAbilities = List.generate(6, (_) => []);

  Map<String, Pokemon> pokemonMap = {};
  String getTypeAsset(String type) {
    return 'assets/type_logos/$type.png';
  }
  String getPokemonSprite(String pokemonName){
    return 'https://play.pokemonshowdown.com/sprites/gen5/${showdownFormatting(pokemonName)}.png';
  }
  String getPokemonImage(int dexNum) {
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
  List<String> getImmuneAbilities(List<String> abilities) {
    return abilities.where((ability) {
      return immuneAbilities.containsKey(ability);
    }).toList();
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
    //print(pokemonMap);
  }

  void loadTypes() async {
    final data = await types();
    setState(() {
      allTypes = data;
    });
  }

  Future<void> loadPokemonData(int index, String name) async {
    final forms = await getForms(name);
    final pokemon = await getPokemon(name);

    /*print("---- DEBUG START ----");
    print("Input name: $name");
    print("Forms fetched: $forms");
    print("Forms length: ${forms.length}");
    print("Pokemon fetched: $pokemon");*/

    setState(() {
      availableForms[index] = forms;

      if (pokemon != null) {
        final allAbilities = [
          pokemon.ability1,
          if (pokemon.ability2 != 'None') pokemon.ability2,
          if (pokemon.abilityH != 'None') pokemon.abilityH
        ];
        availableAbilities[index] = allAbilities;
      } else {
        availableAbilities[index] = [];
      }

      selectedForms[index] = forms.isNotEmpty ? forms.first: null;

      selectedAbilities[index] = availableAbilities[index].isNotEmpty ? availableAbilities[index].first: null;
    });

    /*print("availableForms[$index]: ${availableForms[index]}");
    print("availableAbilities[$index]: ${availableAbilities[index]}");
    print("---- DEBUG END ----");*/
  }

  Widget teamBanner() {
    final topRow = pokemonNames.take(3).toList();
    final bottomRow = pokemonNames.skip(3).take(3).toList();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF311432),
          border: Border.all(color: const Color(0xFFF81894), width: 2),
        ),
        child: SizedBox(
          width: 480,
          height: 240,
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: Container(
                  height: 170,
                  color: Color(0xFFB200ED),
                )
              ),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: topRow.map((name) {
                    final pokemon = pokemonMap[name];
                    if (pokemon == null) {
                      return const SizedBox(width: 80, height: 80);
                    }

                    return Image.network(
                      getPokemonSprite(pokemon.name),
                      width: 120, // slightly bigger for depth
                      height: 120,
                      fit: BoxFit.contain,
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: bottomRow.map((name) {
                    final pokemon = pokemonMap[name];
                    if (pokemon == null) {
                      return const SizedBox(width: 80, height: 80);
                    }

                    return Image.network(
                      getPokemonSprite(pokemon.name),
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          title: Text('Teambuilder'),
        ),
        body: Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Pokemon name input
                      TextField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          labelText: 'Pokemon ${index + 1}',
                        ),
                        onChanged: (value) async {
                          if (value.length <= 2) return;

                          final name = value.trim();

                          final forms = await getForms(name);
                          final pokemon = await getPokemon(name);

                          setState(() {
                            // set forms
                            availableForms[index] = forms;

                            // default selected form
                            selectedForms[index] =
                                forms.isNotEmpty ? forms.first : null;

                            // set abilities from base form
                            if (pokemon != null) {
                              availableAbilities[index] = [
                                pokemon.ability1,
                                if (pokemon.ability2 != 'None') pokemon.ability2,
                                if (pokemon.abilityH != 'None') pokemon.abilityH,
                              ];

                              selectedAbilities[index] =
                                  availableAbilities[index].isNotEmpty
                                      ? availableAbilities[index].first
                                      : null;
                            } else {
                              availableAbilities[index] = [];
                              selectedAbilities[index] = null;
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 6),

                      //Form dropdown
                      if (availableForms[index].length > 1)
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedForms[index] ?? availableForms[index].first,
                          hint: const Text("Form"),
                          items: availableForms[index].map((form) {
                            return DropdownMenuItem(
                              value: form,
                              child: Text(form),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              selectedForms[index] = value;
                            });

                            final pokemon = await getPokemon(
                              controllers[index].text.trim(),
                              form: value == 'None' ? null : value,
                            );

                            setState(() {
                              if (pokemon != null) {
                                availableAbilities[index] = [
                                  pokemon.ability1,
                                  if (pokemon.ability2 != 'None') pokemon.ability2,
                                  if (pokemon.abilityH != 'None') pokemon.abilityH,
                                ];

                                selectedAbilities[index] =
                                    availableAbilities[index].isNotEmpty
                                        ? availableAbilities[index].first
                                        : null;
                              } else {
                                availableAbilities[index] = [];
                                selectedAbilities[index] = null;
                              }
                            });
                          },
                        ),

                      //Ability dropdown
                      if (availableAbilities[index].isNotEmpty)
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedAbilities[index] ??
                              availableAbilities[index].first,
                          hint: const Text("Ability"),
                          items: availableAbilities[index].map((ability) {
                            return DropdownMenuItem(
                              value: ability,
                              child: Text(ability),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedAbilities[index] = value;
                            });
                          },
                        ),
                    ],
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
            teamBanner(),
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
                                    width: 32,
                                    height: 32,
                                    child: Center(
                                      child: pokemon != null ? Image.asset(
                                        getPokemonImage(pokemon.id),
                                        width: 32,
                                        height: 32,
                                      )
                                      : const SizedBox(width: 32, height: 32),
                                    ),
                                  ) 
                                   // fallback UI
                                );
                              }),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  height: 64,
                                  child:Center(child: Text('Total Weaks', style: TextStyle(fontSize: 14))),
                                )
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 100,
                                  height: 64,
                                  child:Center(child: Text('Total Resists', style: TextStyle(fontSize: 14))),
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
                                    final ability = selectedAbilities[pokemonNames.indexOf(name)];
                                    final matchup = getDefMatchup(pokemon.type1, pokemon.type2, ability, type, allTypes);
                                    if (matchup < 1.0) {
                                      totalResists[type] = (totalResists[type] ?? 0) + 1;
                                    }else if (matchup > 1.0){
                                      totalWeaks[type] = (totalWeaks[type] ?? 0) + 1;
                                    }
                                    return DataCell(
                                      SizedBox(
                                        width: 32,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(matchup.toString()),
                                        )
                                      )
                                    );
                                  }),
                                  DataCell(
                                    SizedBox(
                                      width: 64,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(totalWeaks[type].toString()),
                                      )
                                    )
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 64,
                                      child: Align(
                                        alignment: Alignment.center,
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
