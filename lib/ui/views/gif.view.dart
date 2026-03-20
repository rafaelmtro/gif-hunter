import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifView extends StatelessWidget {
  final Map _gifData;

  const GifView(this._gifData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String gifUrl = _gifData['images']['fixed_height']['url'];
    final String title = _gifData['title'] ?? 'GIF Detail';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.orange),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.orange,
            ),
            onPressed: () {
              Share.share(gifUrl);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              gifUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
