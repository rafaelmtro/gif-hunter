import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/giphy.service.dart';

class GifsState {
  final List<dynamic> gifs;
  final String search;
  final String? selectedTag;
  final int offset;
  final bool isLoading;
  final bool isInitialLoading;

  GifsState({
    this.gifs = const [],
    this.search = '',
    this.selectedTag,
    this.offset = 0,
    this.isLoading = false,
    this.isInitialLoading = true,
  });

  GifsState copyWith({
    List<dynamic>? gifs,
    String? search,
    String? selectedTag,
    int? offset,
    bool? isLoading,
    bool? isInitialLoading,
  }) {
    return GifsState(
      gifs: gifs ?? this.gifs,
      search: search ?? this.search,
      selectedTag: selectedTag ?? this.selectedTag,
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
      if (state.search.isEmpty) {
        data = await _giphyService.getTrending(limit: 20);
      } else {
        data = await _giphyService.searchGifs(
          query: state.search,
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

  void updateSearch(String query, {String? tag}) {
    if (state.search == query && state.selectedTag == tag) return;
    
    state = GifsState(search: query, selectedTag: tag, isInitialLoading: true);
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
