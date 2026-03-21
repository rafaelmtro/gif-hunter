import 'package:flutter/material.dart';
import 'gif_actions_overlay.dart';

class GifDetailModal extends StatelessWidget {
  final Map gifData;

  const GifDetailModal({Key? key, required this.gifData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String gifUrl = gifData['images']['fixed_height']['url'];
    final String title = gifData['title'] ?? 'GIF Detail';
    final String? username = gifData['user']?['display_name'] ?? gifData['username'];

    return Dialog(
      backgroundColor: const Color(0xff1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500.0, 
          maxHeight: MediaQuery.of(context).size.height * 0.7
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (username != null && username.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Published by: $username',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Flexible(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Stack(
                      children: [
                        Image.network(
                          gifUrl,
                          fit: BoxFit.contain,
                        ),
                        Positioned.fill(child: GifActionsOverlay(gifData: gifData)),
                      ],
                    ),
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
