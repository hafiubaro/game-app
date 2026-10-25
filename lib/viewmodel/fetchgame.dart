import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/game.dart';
import '../model/detailgame.dart';

const String _baseUrl = 'https://www.freetogame.com/api';

Future<dynamic> _getJson(Uri uri) async {
  late final http.Response response;

  try {
    response = await http.get(uri).timeout(
      const Duration(seconds: 20),
    );
  } on TimeoutException {
    throw Exception(
      'Waktu permintaan habis. Periksa koneksi internet lalu coba lagi.',
    );
  } on http.ClientException {
    throw Exception(
      'Tidak dapat terhubung ke server. Periksa koneksi internet.',
    );
  }

  if (response.statusCode != 200) {
    throw Exception(
      'Server mengembalikan status HTTP ${response.statusCode}.',
    );
  }

  try {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } on FormatException {
    throw Exception('Respons server bukan JSON yang valid.');
  }
}

Future<List<Game>> fetchGames() async {
  final data = await _getJson(Uri.parse('$_baseUrl/games'));

  if (data is! List) {
    throw Exception('Format daftar game tidak sesuai.');
  }

  return data.map<Game>((item) {
    if (item is! Map<String, dynamic>) {
      throw Exception('Format item game tidak sesuai.');
    }

    return Game.fromJson(item);
  }).toList();
}

Future<Map<String, dynamic>> fetchDataFromAPI(int idGame) async {
  final uri = Uri.parse('$_baseUrl/game').replace(
    queryParameters: {'id': idGame.toString()},
  );

  final data = await _getJson(uri);

  if (data is! Map<String, dynamic> || data['id'] is! num) {
    throw Exception('Data detail game tidak tersedia atau tidak valid.');
  }

  return data;
}

Future<DetailGame> fetchDetailGame(int idGame) async {
  final data = await fetchDataFromAPI(idGame);
  return DetailGame.fromJson(data);
}