import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/News/model/news.dart';

Future<List<NewArticleModel>> fetchNews() async {
  try {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/everything?q=women+safety+OR+domestic+violence+OR+safety+awareness&sortBy=publishedAt&language=en'),
      headers: {'X-Api-Key': 'fcdbf060cc944959afda76a67c6d21ca'},
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Request timeout. Please check your internet connection.');
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> articlesJson = jsonResponse['articles'] ?? [];

      if (articlesJson.isEmpty) {
        return [];
      }

      return articlesJson
          .where((json) => json['title'] != null && json['title'].toString().isNotEmpty)
          .map((json) => NewArticleModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key. Please check configuration.');
    } else if (response.statusCode == 429) {
      throw Exception('Too many requests. Please try again later.');
    } else {
      throw Exception('Failed to load news (Status: ${response.statusCode})');
    }
  } catch (e) {
    if (e.toString().contains('timeout') || e.toString().contains('SocketException')) {
      throw Exception('Network error. Please check your internet connection.');
    }
    rethrow;
  }
}
