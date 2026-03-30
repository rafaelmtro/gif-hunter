import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/giphy_notifier.dart';
import 'skeleton_loading.dart';

class TrendingTagsSidebar extends ConsumerWidget {
  final Function(String) onTagToggled;
  final Set<String> selectedTags;

  const TrendingTagsSidebar({
    Key? key,
    required this.onTagToggled,
    required this.selectedTags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingTagsAsync = ref.watch(trendingTagsProvider);

    return Column(
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
                  return _HoverableTag(
                    tag: tag,
                    isSelected: selectedTags.contains(tag),
                    onTap: () => onTagToggled(tag),
                  );
                }).toList(),
              ),
            ),
            loading: () => SingleChildScrollView(
              child: Wrap(
                spacing: 12.0,
                runSpacing: 8.0,
                children: List.generate(
                  15,
                  (index) => const SkeletonLoading(
                    width: 80,
                    height: 24,
                    borderRadius: 8.0,
                  ),
                ),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class _HoverableTag extends StatefulWidget {
  final String tag;
  final bool isSelected;
  final VoidCallback onTap;

  const _HoverableTag({
    Key? key,
    required this.tag,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  __HoverableTagState createState() => __HoverableTagState();
}

class __HoverableTagState extends State<_HoverableTag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: (widget.isSelected || _isHovered) 
                ? Colors.orange.withOpacity(0.15) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: (widget.isSelected || _isHovered) 
                  ? Colors.orange.withOpacity(0.3) 
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Text(
            '#${widget.tag}',
            style: TextStyle(
              color: (widget.isSelected || _isHovered) ? Colors.orange : Colors.white70,
              fontSize: 16.0,
              fontWeight: (widget.isSelected || _isHovered) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
