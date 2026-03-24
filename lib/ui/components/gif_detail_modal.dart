import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'gif_actions_overlay.dart';
import '../../providers/favorites_notifier.dart';

class GifDetailModal extends ConsumerWidget {
  final Map gifData;
  final String heroTag;

  const GifDetailModal({Key? key, required this.gifData, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String animatedUrl = gifData['images']['fixed_height']['url'];
    final String staticUrl = gifData['images']['fixed_height_still']['url'];
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
    
    final favorites = ref.watch(favoritesProvider);
    final bool isFavorite = favorites.any((item) => item['id'] == gifData['id']);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(Map<String, dynamic>.from(gifData));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: animatedUrl));
                          // The overlay inside the modal will still show the "Copied!" indicator
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
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
                        Hero(
                          tag: heroTag,
                          child: Image.network(
                            animatedUrl,
                            fit: BoxFit.contain,
                            gaplessPlayback: true,
                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) return child;
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: frame != null
                                    ? child
                                    : Image.network(
                                        staticUrl,
                                        fit: BoxFit.contain,
                                        gaplessPlayback: true,
                                        key: const ValueKey('static'),
                                      ),
                              );
                            },
                          ),
                        ),
                        Positioned.fill(
                          child: GifActionsOverlay(
                            gifData: gifData,
                            showOnlyCopiedIndicator: true,
                          ),
                        ),
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
