import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nytarticles/models/nytimes_response.dart';

class NYTimesService {
  final String apiKey = 'OZVlzeoz7tgim9QG4zRYHQcMuOfsUjXn';
  final String baseUrl = 'https://api.nytimes.com/svc/search/v2/articlesearch.json';

  Future<NYTimesResponse> fetchArticles({searchedArticle}) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$searchedArticle&api-key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return NYTimesResponse.fromJson(data);
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
