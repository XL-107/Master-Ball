import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
const typeNames = [
  'Normal','Fire','Water','Electric','Grass','Ice',
  'Fighting','Poison','Ground','Flying','Psychic',
  'Bug','Rock','Ghost','Dragon','Dark','Steel','Fairy'
];
Future<Database> initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'type_chart.db');

  // Check if DB already exists
  final exists = await databaseExists(path);

  if (exists) {
    await deleteDatabase(path); // 👈 ADD THIS
  }

  print("Copying database from assets...");

  ByteData data = await rootBundle.load('assets/type_chart.db');
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  await File(path).writeAsBytes(bytes, flush: true);

  return openDatabase(path);
}
//Function that returns all of the types from type_chart.db into the Type class
Future<List<Type>> types() async {
  final db = await initDatabase();
  final List<Map<String, Object?>> typeMaps = await db.query("type_chart");
  return [for (final map in typeMaps) Type.fromMap(map),];
}
/*
Future<List<Pokemon>> pokemon() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'pokemon_test.db'),
  );
  final db = await database;
  final List<Map<String, Object?>> pokemonMaps = await db.query("pokemon_test");
  return [
    for (final{'ID': id as int, 'Name': name as String, 'Type1': type1 as String, 'Type2': type2 as String}
    in pokemonMaps)
    Pokemon(id: id, name: name, type1: type1, type2: type2),
  ];
}*/
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
/*
class Pokemon {
  final int id;
  final String name;
  final String type1;
  final String type2;
  Pokemon({required this.id, required this.name, required this.type1, required this.type2});
}*/
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
class TeambuilderMenu extends StatefulWidget{
  @override
  State<TeambuilderMenu> createState() => TeambuilderMenuState();
}
class TeambuilderMenuState extends State<TeambuilderMenu> {
  List<Type> allTypes = [];

  @override
  void initState() {
    super.initState();
    loadTypes();
  }

  void loadTypes() async {
    final data = await types();
    setState(() {
      allTypes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp with debugShowCheckedModeBanner false and home
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        // Scaffold with appbar ans body.
        appBar: AppBar(
          title: Text('Pokemon Type Chart'),
        ),
        body:
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            // Datatable widget that have the property columns and rows.
            columns: [
              // Set the name of the column
              DataColumn(label: Text('Type'),),
              DataColumn(label: Text('Infernape'),),
              DataColumn(label: Text('Milotic'),),
              DataColumn(label: Text('Weavile'),),
              DataColumn(label: Text('Magnezone'),),
              DataColumn(label: Text('Gliscor'),),
              DataColumn(label: Text('Flygon'),),
            ],
            rows: typeNames.map((type) {
              return DataRow(
                cells: [
                  DataCell(Text(type)),
                  DataCell(Text(getDefMatchup('Fire', 'Fighting', type, allTypes).toString())),
                  DataCell(Text(getDefMatchup('Water', 'Fairy', type, allTypes).toString())),
                  DataCell(Text(getDefMatchup('Ice', 'Dark', type, allTypes).toString())),
                  DataCell(Text(getDefMatchup('Electric', 'Steel', type, allTypes).toString())),
                  DataCell(Text(getDefMatchup('Ground', 'Flying', type, allTypes).toString())),
                  DataCell(Text(getDefMatchup('Bug', 'Dragon', type, allTypes).toString())),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
