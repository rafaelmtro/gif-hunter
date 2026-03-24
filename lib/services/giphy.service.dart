import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final giphyServiceProvider = Provider((ref) => GiphyService());

class GiphyService {
  final Dio _dio;
  static const String _apiKey = 'nFpRCivJ74jdZjHMPgp2qsKDobPWhE4e';
  static const String _baseUrl = 'https://api.giphy.com/v1';

  GiphyService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> getTrending({int limit = 20, int offset = 0, String rating = 'g'}) async {
    final response = await _dio.get(
      '$_baseUrl/gifs/trending',
      queryParameters: {
        'api_key': _apiKey,
        'limit': limit,
        'offset': offset,
        'rating': rating,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> searchGifs({
    required String query,
    int limit = 20,
    int offset = 0,
    String rating = 'g',
    String lang = 'en',
  }) async {
    final response = await _dio.get(
      '$_baseUrl/gifs/search',
      queryParameters: {
        'api_key': _apiKey,
        'q': query,
        'limit': limit,
        'offset': offset,
        'rating': rating,
        'lang': lang,
      },
    );
    return response.data;
  }

  Future<List<String>> getTrendingSearches() async {
    final response = await _dio.get(
      '$_baseUrl/trending/searches',
      queryParameters: {
        'api_key': _apiKey,
      },
    );
    return List<String>.from(response.data['data']);
  }
}
