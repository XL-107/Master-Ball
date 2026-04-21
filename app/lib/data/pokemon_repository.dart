import 'package:sqflite/sqflite.dart';
import '../dbaccess.dart';
import 'database_helper.dart';

class PokemonRepository {
  Future<List<Map<String, dynamic>>> searchByName(String query) async {
    final db = await DatabaseHelper.database;

    return await db.rawQuery(
      '''
      SELECT Number, Name, Form, Type1, Type2
      FROM expanded_pokemon_test
      WHERE Name LIKE ? || '%'
      ORDER BY Name
      LIMIT 50
      ''',
      [query],
    );
  }

  Future<List<Map<String, dynamic>>> filterByType(String type) async {
    final db = await DatabaseHelper.database;

    return await db.rawQuery(
      '''
      SELECT Number, Name, Form, Type1, Type2
      FROM expanded_pokemon_test
      WHERE Type1 = ? OR Type2 = ?
      ORDER BY Number
      LIMIT 50
      ''',
      [type, type],
    );
  }

  Future<List<Map<String, dynamic>>> sortByTotal() async {
    final db = await DatabaseHelper.database;

    return await db.rawQuery(
      '''
      SELECT Number, Name, Form, Total
      FROM pokemon_with_total
      ORDER BY Total DESC
      LIMIT 50
      '''
    );
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      'pokemon',
      where: 'EntryId = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }
}
