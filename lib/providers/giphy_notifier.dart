import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/giphy.service.dart';

class GifsState {
  final List<dynamic> gifs;
  final String search;
  final Set<String> selectedTags;
  final int offset;
  final bool isLoading;
  final bool isInitialLoading;

  GifsState({
    this.gifs = const [],
    this.search = '',
    this.selectedTags = const {},
    this.offset = 0,
    this.isLoading = false,
    this.isInitialLoading = true,
  });

  GifsState copyWith({
    List<dynamic>? gifs,
    String? search,
    Set<String>? selectedTags,
    int? offset,
    bool? isLoading,
    bool? isInitialLoading,
  }) {
    return GifsState(
      gifs: gifs ?? this.gifs,
      search: search ?? this.search,
      selectedTags: selectedTags ?? this.selectedTags,
      offset: offset ?? this.offset,
      isLoading: isLoading ?? this.isLoading,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
    );
  }
}

class GifsNotifier extends StateNotifier<GifsState> {
  final GiphyService _giphyService;

  GifsNotifier(this._giphyService) : super(GifsState()) {
    fetchGifs();
  }

  Future<void> fetchGifs() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true);
    
    try {
      final Map<String, dynamic> data;
      // Combine manual search with tags
      String finalQuery = state.search;
      if (state.selectedTags.isNotEmpty) {
        final tagsQuery = state.selectedTags.join(' ');
        finalQuery = finalQuery.isEmpty ? tagsQuery : '$finalQuery $tagsQuery';
      }

      if (finalQuery.isEmpty) {
        data = await _giphyService.getTrending(limit: 20);
      } else {
        data = await _giphyService.searchGifs(
          query: finalQuery,
          limit: 20,
          offset: state.offset,
        );
      }
      
      state = state.copyWith(
        gifs: [...state.gifs, ...data['data']],
        offset: state.offset + 20,
        isLoading: false,
        isInitialLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isInitialLoading: false);
    }
  }

  void updateSearch(String query) {
    if (state.search == query) return;
    
    // Clear tags when user starts typing a new manual search
    state = GifsState(search: query, selectedTags: {}, isInitialLoading: true);
    fetchGifs();
  }

  void toggleTag(String tag) {
    final newTags = Set<String>.from(state.selectedTags);
    if (newTags.contains(tag)) {
      newTags.remove(tag);
    } else {
      newTags.add(tag);
    }
    
    state = GifsState(
      search: state.search,
      selectedTags: newTags,
      isInitialLoading: true,
    );
    fetchGifs();
  }

  void loadMore() {
    fetchGifs();
  }
}

final gifsProvider = StateNotifierProvider<GifsNotifier, GifsState>((ref) {
  final giphyService = ref.watch(giphyServiceProvider);
  return GifsNotifier(giphyService);
});

final trendingTagsProvider = FutureProvider<List<String>>((ref) async {
  final giphyService = ref.watch(giphyServiceProvider);
  return giphyService.getTrendingSearches();
});
