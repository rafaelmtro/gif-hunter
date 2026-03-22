import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/giphy_notifier.dart';
import '../components/favorites_modal.dart';
import '../components/gif_item.dart';
import '../components/skeleton_loading.dart';
import '../components/trending_tags_sidebar.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _textEditCtrl = TextEditingController();
  final _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    if (state.search.isEmpty && _textEditCtrl.text.isNotEmpty) {
      _textEditCtrl.clear();
    }
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: isMobile ? Drawer(
        backgroundColor: const Color(0xff1A1A1A),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftSidebarContent(isDrawer: true),
                const SizedBox(height: 30.0),
                Expanded(
                  child: TrendingTagsSidebar(
                    onTagToggled: _onTagToggled,
                    selectedTags: state.selectedTags,
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              _buildHeader(isMobile),
              const SizedBox(height: 20.0),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile) ...[
                      _buildLeftSidebar(),
                      const SizedBox(width: 20.0),
                    ],
                    _buildMainContent(state, isMobile),
                    if (!isMobile) ...[
                      const SizedBox(width: 40.0),
                      SizedBox(
                        width: 220.0,
                        child: TrendingTagsSidebar(
                          onTagToggled: _onTagToggled,
                          selectedTags: state.selectedTags,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isMobile)
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.orange),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        if (!isMobile)
          Container(
            width: 150.0,
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
        if (!isMobile) const SizedBox(width: 20.0),
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
              prefixIcon: isMobile ? const Icon(Icons.search, color: Colors.orange) : null,
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
        if (!isMobile) const Spacer(flex: 1),
      ],
    );
  }

  Widget _buildLeftSidebar() {
    return SizedBox(
      width: 150.0,
      child: _buildLeftSidebarContent(),
    );
  }

  Widget _buildLeftSidebarContent({bool isDrawer = false}) {
    return Column(
      crossAxisAlignment: isDrawer ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            if (isDrawer) Navigator.of(context).pop();
            _showFavorites();
          },
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.favorite, color: Colors.orange, size: 20.0),
                SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(GifsState state, bool isMobile) {
    return Expanded(
      flex: 4,
      child: state.isInitialLoading 
        ? _buildSkeletonGrid(isMobile)
        : _buildGifGrid(state, isMobile),
    );
  }

  Widget _buildSkeletonGrid(bool isMobile) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 5,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 20,
      itemBuilder: (context, index) => SkeletonLoading(),
    );
  }

  Widget _buildGifGrid(GifsState state, bool isMobile) {
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 5,
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
