import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_hunter/ui/views/home.view.dart';
import 'package:gif_hunter/services/giphy.service.dart';
import 'package:mocktail/mocktail.dart';

class MockGiphyService extends Mock implements GiphyService {}

void main() {
  late MockGiphyService mockGiphyService;

  setUp(() {
    mockGiphyService = MockGiphyService();
    
    // Default mock responses
    when(() => mockGiphyService.getTrending(limit: any(named: 'limit')))
        .thenAnswer((_) async => {'data': []});
    when(() => mockGiphyService.getTrendingSearches())
        .thenAnswer((_) async => ['tag1', 'tag2']);
  });

  testWidgets('HomeView responsive layout - Desktop', (WidgetTester tester) async {
    // Set desktop screen size
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          giphyServiceProvider.overrideWithValue(mockGiphyService),
        ],
        child: const MaterialApp(
          home: HomeView(),
        ),
      ),
    );

    // Initial pump to handle FutureProvider
    await tester.pump();

    // Desktop should NOT have a menu button for drawer
    expect(find.byIcon(Icons.menu), findsNothing);
    // Desktop should have 'GIF Hunter' title in header
    expect(find.text('GIF Hunter'), findsOneWidget);

    // Reset screen size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('HomeView responsive layout - Mobile', (WidgetTester tester) async {
    // Set mobile screen size
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          giphyServiceProvider.overrideWithValue(mockGiphyService),
        ],
        child: const MaterialApp(
          home: HomeView(),
        ),
      ),
    );

    // Initial pump to handle FutureProvider
    await tester.pump();

    // Mobile should HAVE a menu button for drawer
    expect(find.byIcon(Icons.menu), findsOneWidget);
    // Mobile should NOT have 'GIF Hunter' title in header
    expect(find.text('GIF Hunter'), findsNothing);

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Check if drawer content is there (Trending Tags)
    expect(find.text('Trending Tags'), findsOneWidget);
    expect(find.text('#tag1'), findsOneWidget);

    // Reset screen size
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
