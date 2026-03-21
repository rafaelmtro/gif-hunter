import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/giphy_notifier.dart';

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

    return SizedBox(
      width: 220.0,
      child: Column(
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
                    final isSelected = selectedTags.contains(tag);
                    return InkWell(
                      onTap: () => onTagToggled(tag),
                      borderRadius: BorderRadius.circular(8.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            color: isSelected ? Colors.orange : Colors.white70,
                            fontSize: 16.0,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.orange)),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
