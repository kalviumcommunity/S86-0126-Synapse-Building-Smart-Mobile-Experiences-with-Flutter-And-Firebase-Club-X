import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/riverpod_providers.dart';

/// Riverpod Favorites Demo - Screen A
/// Demonstrates adding items to favorites using Riverpod
/// State is shared and accessed from multiple screens
class RiverpodFavoritesScreen extends ConsumerWidget {
  const RiverpodFavoritesScreen({super.key});

  static const List<String> availableItems = [
    '📚 Clean Architecture',
    '🎵 Stairway to Heaven',
    '🎬 Inception',
    '🎮 Minecraft',
    '🍕 Pepperoni Pizza',
    '☕ Cappuccino',
    '🏖️ Bali',
    '🎨 Mona Lisa',
    '📱 Dart Language',
    '💻 Android Studio',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the favorites state
    final favorites = ref.watch(favoritesProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Favorites'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // Show count using computed provider
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '❤️ $favoritesCount',
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tap items to add/remove from favorites',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableItems.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = availableItems[index];
                final isFav = favorites.contains(item);

                return Card(
                  elevation: isFav ? 4 : 1,
                  color: isFav ? Colors.teal.shade50 : null,
                  child: ListTile(
                    title: Text(
                      item,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isFav ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        // Update shared state - immutable update
                        ref.read(favoritesProvider.notifier).toggleFavorite(item);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiverpodFavoritesViewScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Favorites'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (favoritesCount > 0)
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).clearAll();
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Riverpod Favorites View - Screen B
/// Demonstrates reading shared state from a different screen
/// Shows how UI stays in sync across multiple screens
class RiverpodFavoritesViewScreen extends ConsumerWidget {
  const RiverpodFavoritesViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access same state instance - no data passing needed!
    final favorites = ref.watch(favoritesProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: favoritesCount == 0
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Go back and add some items',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.teal.shade50,
                  child: Text(
                    '$favoritesCount Favorites',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favoritesCount,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final item = favorites[index];
                      return Card(
                        color: Colors.red.shade50,
                        child: ListTile(
                          leading: const Icon(Icons.favorite, color: Colors.red),
                          title: Text(
                            item,
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Remove from shared state
                              ref.read(favoritesProvider.notifier).removeItem(item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    color: Colors.green,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Riverpod state is immutable and synchronized across all screens!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
