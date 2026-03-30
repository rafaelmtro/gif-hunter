import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_hunter/services/giphy.service.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late GiphyService giphyService;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    giphyService = GiphyService(dio: dio);
  });

  group('GiphyService', () {
    test('getTrending returns data when successful', () async {
      const path = 'https://api.giphy.com/v1/gifs/trending';
      final mockResponse = {
        'data': [
          {'id': '1', 'title': 'GIF 1'}
        ]
      };

      dioAdapter.onGet(
        path,
        (server) => server.reply(200, mockResponse),
        queryParameters: {
          'api_key': 'nFpRCivJ74jdZjHMPgp2qsKDobPWhE4e',
          'limit': 20,
          'rating': 'g',
        },
      );

      final result = await giphyService.getTrending();

      expect(result, equals(mockResponse));
    });

    test('searchGifs returns data when successful', () async {
      const path = 'https://api.giphy.com/v1/gifs/search';
      const query = 'dogs';
      final mockResponse = {
        'data': [
          {'id': '2', 'title': 'Dog GIF'}
        ]
      };

      dioAdapter.onGet(
        path,
        (server) => server.reply(200, mockResponse),
        queryParameters: {
          'api_key': 'nFpRCivJ74jdZjHMPgp2qsKDobPWhE4e',
          'q': query,
          'limit': 20,
          'offset': 0,
          'rating': 'g',
          'lang': 'en',
        },
      );

      final result = await giphyService.searchGifs(query: query);

      expect(result, equals(mockResponse));
    });
  });
}
