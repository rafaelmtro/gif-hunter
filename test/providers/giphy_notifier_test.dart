import 'package:flutter_test/flutter_test.dart';
import 'package:gif_hunter/providers/giphy_notifier.dart';
import 'package:gif_hunter/services/giphy.service.dart';
import 'package:mocktail/mocktail.dart';

class MockGiphyService extends Mock implements GiphyService {}

void main() {
  late MockGiphyService mockGiphyService;

  setUp(() {
    mockGiphyService = MockGiphyService();
  });

  test('GifsNotifier filters duplicate IDs', () async {
    final gif1 = {'id': '1', 'title': 'Gif 1'};
    final gif2 = {'id': '2', 'title': 'Gif 2'};
    
    // Initial fetch returns gif1 and gif2
    when(() => mockGiphyService.getTrending(limit: 20, offset: 0))
        .thenAnswer((_) async => {
          'data': [gif1, gif2]
        });

    final notifier = GifsNotifier(mockGiphyService);
    
    // Wait for initial fetch
    await Future.microtask(() {}); 
    
    expect(notifier.state.gifs.length, 2);
    expect(notifier.state.gifs[0]['id'], '1');
    expect(notifier.state.gifs[1]['id'], '2');

    // Load more returns gif2 (duplicate) and gif3
    final gif3 = {'id': '3', 'title': 'Gif 3'};
    when(() => mockGiphyService.getTrending(limit: 20, offset: 20))
        .thenAnswer((_) async => {
          'data': [gif2, gif3]
        });

    await notifier.loadMore();
    
    // Total should be 3 (gif1, gif2, gif3), gif2 should not be duplicated
    expect(notifier.state.gifs.length, 3);
    expect(notifier.state.gifs.map((g) => g['id']).toList(), ['1', '2', '3']);
  });
}
