import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'gif_detail_modal.dart';
import 'gif_actions_overlay.dart';

class HoverableGifItem extends ConsumerStatefulWidget {
  final Map gifData;

  const HoverableGifItem({Key? key, required this.gifData}) : super(key: key);

  @override
  _HoverableGifItemState createState() => _HoverableGifItemState();
}

class _HoverableGifItemState extends ConsumerState<HoverableGifItem> {
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
          showDialog(
            context: context,
            builder: (context) => GifDetailModal(gifData: widget.gifData),
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
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              GifActionsOverlay(gifData: widget.gifData),
            ],
          ),
        ),
      ),
    );
  }
}
