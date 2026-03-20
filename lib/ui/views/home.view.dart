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
  String? _search;
  int _offset = 0;
  Timer? _debounce;

  _getGigs() async {
    final search = _search;
    if (search == null || search.isEmpty) {
      return _giphyService.getTrending(limit: 20);
    } else {
      return _giphyService.searchGifs(
        query: search,
        limit: 19,
        offset: _offset,
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textEditCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _search = text;
        _offset = 0;
      });
    });
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
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
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
                future: _getGigs(),
                builder: (context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        height: 200.0,
                        width: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return _createGigTable(context, snapshot);
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

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGigTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data['data'].length) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return GifView(snapshot.data['data'][index]);
                  },
                ),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    'Load more...',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
