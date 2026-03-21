import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/giphy_notifier.dart';
import '../components/favorites_modal.dart';
import '../components/gif_item.dart';
import '../components/skeleton_loading.dart';
import '../components/trending_tags_sidebar.dart';

class HomeView extends ConsumerStatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _textEditCtrl = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
        ref.read(gifsProvider.notifier).loadMore();
      }
    });
  }

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(gifsProvider.notifier).updateSearch(text);
    });
  }

  void _onTagToggled(String tag) {
    ref.read(gifsProvider.notifier).toggleTag(tag);
  }

  void _showFavorites() {
    showDialog(
      context: context,
      builder: (context) => FavoritesModal(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textEditCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gifsProvider);

    if (state.search.isEmpty && _textEditCtrl.text.isNotEmpty) {
      _textEditCtrl.clear();
    }
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              _buildHeader(),
              const SizedBox(height: 20.0),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeftSidebar(),
                    const SizedBox(width: 20.0),
                    _buildMainContent(state),
                    const SizedBox(width: 40.0),
                    TrendingTagsSidebar(
                      onTagToggled: _onTagToggled,
                      selectedTags: state.selectedTags,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150.0,
          padding: const EdgeInsets.only(top: 10.0),
          alignment: Alignment.centerRight,
          child: const Text(
            'GIF Hunter',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          flex: 2,
          child: TextField(
            controller: _textEditCtrl,
            onChanged: _onSearchChanged,
            onSubmitted: (text) {
              _debounce?.cancel();
              ref.read(gifsProvider.notifier).updateSearch(text);
            },
            textAlign: TextAlign.left,
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              hintText: 'Search here',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xff1A1A1A),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.orange, width: 1.0),
              ),
            ),
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }

  Widget _buildLeftSidebar() {
    return SizedBox(
      width: 150.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: _showFavorites,
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.favorite, color: Colors.orange, size: 20.0),
                  SizedBox(width: 10.0),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(GifsState state) {
    return Expanded(
      flex: 4,
      child: state.isInitialLoading 
        ? _buildSkeletonGrid()
        : _buildGifGrid(state),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 20,
      itemBuilder: (context, index) => SkeletonLoading(),
    );
  }

  Widget _buildGifGrid(GifsState state) {
    if (state.gifs.isEmpty) {
      return const Center(
        child: Text(
          "No GIFs found",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: state.gifs.length,
            itemBuilder: (context, index) {
              return HoverableGifItem(gifData: state.gifs[index]);
            },
          ),
        ),
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          ),
      ],
    );
  }
}
