import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
const typeNames = [
  'Normal','Fire','Water','Electric','Grass','Ice',
  'Fighting','Poison','Ground','Flying','Psychic',
  'Bug','Rock','Ghost','Dragon','Dark','Steel','Fairy'
];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TeambuilderMenu());
  final database = openDatabase(
    join(await getDatabasesPath(), 'type_chart.db'),
  );
  Future<List<Type>> types() async {
    final db = await database;
    final List<Map<String, Object?>> typeMaps = await db.query("type_chart");
    return [for (final map in typeMaps) Type.fromMap(map),];
  }
}
class Type{
  final String type;
  final List<double> typeMatchups;
  Type({required this.type, required this.typeMatchups});
  Map<String, Object?> toMap() {
    return {'Type Name': type, 
    'normal': typeMatchups[0], 
    'fire': typeMatchups[1],
    'water': typeMatchups[2],
    'electric': typeMatchups[3],
    'grass': typeMatchups[4],
    'ice': typeMatchups[5],
    'fighting': typeMatchups[6],
    'poison': typeMatchups[7],
    'ground': typeMatchups[8],
    'flying': typeMatchups[9],
    'psychic': typeMatchups[10],
    'bug': typeMatchups[11],
    'rock': typeMatchups[12],
    'ghost': typeMatchups[13],
    'dragon': typeMatchups[14],
    'dark': typeMatchups[15],
    'steel': typeMatchups[16],
    'fairy': typeMatchups[17]};
  }
  factory Type.fromMap(Map<String, Object?> map) {
    return Type(
      type: map['Type Name'] as String,
      typeMatchups: [
        (map['normal'] as num).toDouble(),
        (map['fire'] as num).toDouble(),
        (map['water'] as num).toDouble(),
        (map['electric'] as num).toDouble(),
        (map['grass'] as num).toDouble(),
        (map['ice'] as num).toDouble(),
        (map['fighting'] as num).toDouble(),
        (map['poison'] as num).toDouble(),
        (map['ground'] as num).toDouble(),
        (map['flying'] as num).toDouble(),
        (map['psychic'] as num).toDouble(),
        (map['bug'] as num).toDouble(),
        (map['rock'] as num).toDouble(),
        (map['ghost'] as num).toDouble(),
        (map['dragon'] as num).toDouble(),
        (map['dark'] as num).toDouble(),
        (map['steel'] as num).toDouble(),
        (map['fairy'] as num).toDouble(),
      ],
    );
  }
}

class TeambuilderMenu extends StatelessWidget{
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
              DataColumn(label: Text('Pokemon 1'),),
              DataColumn(label: Text('Pokemon 2'),),
              DataColumn(label: Text('Pokemon 3'),),
              DataColumn(label: Text('Pokemon 4'),),
              DataColumn(label: Text('Pokemon 5'),),
              DataColumn(label: Text('Pokemon 6'),),
            ],
            rows: typeNames.map((type) {
              return DataRow(
                cells: [
                  DataCell(Text(type)),
                  ...List.generate(6, (_) => DataCell(Text(''))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
/*
typedef TeamEntry = DropdownMenuEntry<Team>;

enum Team {
  infernape('Infernape'),
  milotic('Milotic'),
  weavile('Weavile'),
  magnezone('Magnezone'),
  gliscor('Gliscor'),
  flygon('Flygon');

  const Team(this.label);
  final String label;

  static final List<TeamEntry> entries = UnmodifiableListView<TeamEntry>(
    values.map<TeamEntry>(
      (Team pokemon) => TeamEntry(
        value: pokemon,
        label: pokemon.label,
        style: MenuItemButton.styleFrom(foregroundColor: Colors.black),
      ),
    ),
  );
}

class TeambuilderMenu extends StatefulWidget {
  const TeambuilderMenu({super.key});

  @override
  State<TeambuilderMenu> createState() => TeambuilderMenuState();
}

class TeambuilderMenuState() extends State<TeambuilderMenu> {
  
}*/
