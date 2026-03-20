import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../providers/giphy_notifier.dart';
import 'gif.view.dart';

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
    final trendingTagsAsync = ref.watch(trendingTagsProvider);

    // Sync controller with state (clearing it when state search is cleared)
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.0,
                    padding: const EdgeInsets.only(top: 10.0),
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
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 170.0), // Space matching the name + gap
                    Expanded(
                      flex: 4,
                      child: state.isInitialLoading 
                        ? _buildSkeletonGrid()
                        : _createGigTable(context, state.gifs),
                    ),
                    const SizedBox(width: 40.0),
                    // Dedicated Trending Tags Sidebar
                    SizedBox(
                      width: 220.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trending Tags',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Expanded(
                            child: trendingTagsAsync.when(
                              data: (tags) => SingleChildScrollView(
                                child: Wrap(
                                  spacing: 12.0,
                                  runSpacing: 8.0,
                                  alignment: WrapAlignment.start,
                                  children: tags.map((tag) {
                                    final isSelected = state.selectedTags.contains(tag);
                                    return InkWell(
                                      onTap: () => _onTagToggled(tag),
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          '#$tag',
                                          style: TextStyle(
                                            color: isSelected ? Colors.orange : Colors.white70,
                                            fontSize: 16.0,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              loading: () => const Center(child: CircularProgressIndicator(color: Colors.orange)),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
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

  Widget _createGigTable(BuildContext context, List data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No GIFs found",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return HoverableGifItem(gifData: data[index]);
      },
    );
  }
}

class HoverableGifItem extends StatefulWidget {
  final Map gifData;

  const HoverableGifItem({Key? key, required this.gifData}) : super(key: key);

  @override
  _HoverableGifItemState createState() => _HoverableGifItemState();
}

class _HoverableGifItemState extends State<HoverableGifItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final String staticUrl = widget.gifData['images']['fixed_height_still']['url'];
    final String animatedUrl = widget.gifData['images']['fixed_height']['url'];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return GifView(widget.gifData);
              },
            ),
          );
        },
        onLongPress: () {
          setState(() => _isHovered = true);
          Share.share(animatedUrl);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _isHovered ? animatedUrl : staticUrl,
                height: 300.0,
                width: 300.0,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 5.0,
                right: 5.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white, size: 20.0),
                    tooltip: 'Copy Link',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: animatedUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copied to clipboard!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonLoading extends StatefulWidget {
  @override
  _SkeletonLoadingState createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
