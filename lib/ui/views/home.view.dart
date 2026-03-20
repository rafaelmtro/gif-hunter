import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../services/giphy.service.dart';
import 'gif.view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _textEditCtrl = TextEditingController();
  final _giphyService = GiphyService();
  final _scrollController = ScrollController();
  
  String? _search;
  int _offset = 0;
  Timer? _debounce;
  
  List<dynamic> _gifs = [];
  bool _loading = false;
  Future? _future;

  @override
  void initState() {
    super.initState();
    _future = _getGigs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
        if (!_loading) {
          _loadMore();
        }
      }
    });
  }

  Future _getGigs() async {
    _loading = true;
    final search = _search;
    Map<String, dynamic> data;
    if (search == null || search.isEmpty) {
      data = await _giphyService.getTrending(limit: 20);
    } else {
      data = await _giphyService.searchGifs(
        query: search,
        limit: 20,
        offset: _offset,
      );
    }
    _gifs.addAll(data['data']);
    _loading = false;
    return _gifs;
  }

  void _loadMore() {
    setState(() {
      _offset += 20;
      _future = _getGigs();
    });
  }

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _resetSearch(text);
    });
  }

  void _resetSearch(String text) {
    setState(() {
      _search = text;
      _offset = 0;
      _gifs = [];
      _future = _getGigs();
    });
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
    return Scaffold(
      backgroundColor: Color(0xff4C4E52),
      appBar: AppBar(
        backgroundColor: Color(0xff2E3033),
        title: Image.asset(
          'images/header.png',
          height: 40.0,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 100.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _textEditCtrl,
                onChanged: _onSearchChanged,
                onSubmitted: (text) {
                  _debounce?.cancel();
                  _resetSearch(text);
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff6F7378),
                  border: OutlineInputBorder(),
                  labelText: 'Search here',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      if (_gifs.isEmpty) {
                        return _buildSkeletonGrid();
                      }
                      return _createGigTable(context, _gifs);
                    case ConnectionState.none:
                      return _buildSkeletonGrid();
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return _createGigTable(context, _gifs);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 20,
      itemBuilder: (context, index) => SkeletonLoading(),
    );
  }

  Widget _createGigTable(BuildContext context, List data) {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GifView(data[index]);
                },
              ),
            );
          },
          onLongPress: () {
            Share.share(data[index]['images']['fixed_height']['url']);
          },
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: data[index]['images']['fixed_height']['url'],
            height: 300.0,
            fit: BoxFit.cover,
          ),
        );
      },
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
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
