import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/favorites_notifier.dart';

class GifActionsOverlay extends ConsumerStatefulWidget {
  final Map gifData;
  final bool showOnlyCopiedIndicator;

  const GifActionsOverlay({
    Key? key, 
    required this.gifData,
    this.showOnlyCopiedIndicator = false,
  }) : super(key: key);

  @override
  _GifActionsOverlayState createState() => _GifActionsOverlayState();
}

class _GifActionsOverlayState extends ConsumerState<GifActionsOverlay> {
  bool _showCopiedIndicator = false;

  void _onCopy(String animatedUrl) {
    Clipboard.setData(ClipboardData(text: animatedUrl));
    setState(() => _showCopiedIndicator = true);
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showCopiedIndicator = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String animatedUrl = widget.gifData['images']['fixed_height']['url'];
    final favorites = ref.watch(favoritesProvider);
    final bool isFavorite = favorites.any((item) => item['id'] == widget.gifData['id']);

    final size = MediaQuery.of(context).size;
    final isVerySmall = size.width < 600;
    
    final iconSize = isVerySmall ? 16.0 : 20.0;
    final buttonPadding = isVerySmall ? 4.0 : 8.0;

    return Stack(
      children: [
        if (!widget.showOnlyCopiedIndicator)
          Positioned(
            top: isVerySmall ? 8.0 : 5.0,
            right: isVerySmall ? 8.0 : 5.0,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(buttonPadding),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: iconSize,
                    ),
                    tooltip: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(Map<String, dynamic>.from(widget.gifData));
                    },
                  ),
                ),
                const SizedBox(width: 5.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(buttonPadding),
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.copy, color: Colors.white, size: iconSize),
                    tooltip: 'Copy Link',
                    onPressed: () => _onCopy(animatedUrl),
                  ),
                ),
              ],
            ),
          ),
        if (_showCopiedIndicator)
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showCopiedIndicator ? 1.0 : 0.0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.orange, size: 40.0),
                      SizedBox(height: 8.0),
                      Text(
                        'Copied!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
