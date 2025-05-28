import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/location.dart';

class ApiRepository {
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> getCharacters({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/character?page=$page'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<Character> getCharacter(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/character/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Character.fromJson(data);
    } else {
      throw Exception('Failed to load character');
    }
  }

  Future<List<Location>> getLocations({int page = 1}) async {
    final response = await http.get(Uri.parse('$_baseUrl/location?page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<Location> getLocation(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/location/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Location.fromJson(data);
    } else {
      throw Exception('Failed to load location');
    }
  }
}
