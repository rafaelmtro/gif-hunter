import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../providers/favorites_notifier.dart';
import 'gif_detail_modal.dart';
import 'gif_actions_overlay.dart';

class HoverableGifItem extends ConsumerStatefulWidget {
  final Map gifData;
  final String? heroTagPrefix;

  const HoverableGifItem({Key? key, required this.gifData, this.heroTagPrefix}) : super(key: key);

  @override
  _HoverableGifItemState createState() => _HoverableGifItemState();
}

class _HoverableGifItemState extends ConsumerState<HoverableGifItem> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
    _scaleController.value = 1.0;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleUnheart() {
    _scaleController.reverse().then((_) {
      ref.read(favoritesProvider.notifier).toggleFavorite(Map<String, dynamic>.from(widget.gifData));
    });
  }

  @override
  Widget build(BuildContext context) {
    final String staticUrl = widget.gifData['images']['fixed_height_still']['url'];
    final String animatedUrl = widget.gifData['images']['fixed_height']['url'];
    final String heroTag = widget.heroTagPrefix != null 
        ? '${widget.heroTagPrefix}_${widget.gifData['id']}' 
        : widget.gifData['id'];

    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                pageBuilder: (context, _, __) => GifDetailModal(
                  gifData: widget.gifData,
                  heroTag: heroTag,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
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
                Hero(
                  tag: heroTag,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: _isHovered ? animatedUrl : staticUrl,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                GifActionsOverlay(
                  gifData: widget.gifData,
                  onUnheart: widget.heroTagPrefix == 'fav' ? _handleUnheart : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
