import 'package:flutter/material.dart';
import 'gif_actions_overlay.dart';

class GifDetailModal extends StatelessWidget {
  final Map gifData;

  const GifDetailModal({Key? key, required this.gifData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String gifUrl = gifData['images']['fixed_height']['url'];
    final String fullTitle = gifData['title'] ?? 'GIF Detail';
    
    // Parse title and author
    String title = fullTitle;
    String? authorFromTitle;
    if (fullTitle.contains(' by ')) {
      final parts = fullTitle.split(' by ');
      title = parts[0];
      authorFromTitle = parts[1];
    }
    
    final String? username = gifData['user']?['display_name'] ?? gifData['username'] ?? authorFromTitle;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Dialog(
      backgroundColor: const Color(0xff1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.0 : 40.0,
        vertical: 24.0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? size.width * 0.9 : 500.0, 
          maxHeight: size.height * (isMobile ? 0.8 : 0.7)
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
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
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: isMobile ? 20.0 : 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (username != null && username.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Published by: $username',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isMobile ? 16.0 : 18.0,
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
