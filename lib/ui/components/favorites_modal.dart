import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/favorites_notifier.dart';
import 'gif_item.dart';

class FavoritesModal extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Dialog(
      backgroundColor: const Color(0xff1A1A1A),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorite GIFs',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: favorites.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Text(
                          'No favorites yet. Start hearting some GIFs!',
                          style: TextStyle(color: Colors.white70, fontSize: 18.0),
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        return HoverableGifItem(gifData: favorites[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
