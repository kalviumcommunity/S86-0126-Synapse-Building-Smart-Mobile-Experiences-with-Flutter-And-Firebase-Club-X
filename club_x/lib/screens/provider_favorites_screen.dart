import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_state.dart';

/// Provider Favorites Demo - Screen A
/// Demonstrates adding items to favorites
/// State is shared and accessed from multiple screens
class ProviderFavoritesScreen extends StatelessWidget {
  const ProviderFavoritesScreen({super.key});

  static const List<String> availableItems = [
    '📚 Clean Code',
    '🎵 Bohemian Rhapsody',
    '🎬 The Matrix',
    '🎮 The Legend of Zelda',
    '🍕 Margherita Pizza',
    '☕ Espresso',
    '🏖️ Maldives',
    '🎨 Starry Night',
    '📱 Flutter Framework',
    '💻 Visual Studio Code',
  ];

  @override
  Widget build(BuildContext context) {
    // Watch the favorites state
    final favorites = context.watch<FavoritesState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Favorites'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Show count of favorites
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '❤️ ${favorites.itemCount}',
                style: const TextStyle(
                  color: Colors.deepPurple,
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
                final isFav = favorites.isFavorite(item);

                return Card(
                  elevation: isFav ? 4 : 1,
                  color: isFav ? Colors.deepPurple.shade50 : null,
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
                        // Update shared state - triggers rebuild everywhere
                        context.read<FavoritesState>().toggleFavorite(item);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProviderFavoritesViewScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Favorites'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (favorites.itemCount > 0)
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FavoritesState>().clearAll();
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

/// Provider Favorites View - Screen B
/// Demonstrates reading shared state from a different screen
/// Shows how UI stays in sync across multiple screens
class ProviderFavoritesViewScreen extends StatelessWidget {
  const ProviderFavoritesViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access same state instance - no data passing needed!
    final favorites = context.watch<FavoritesState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: favorites.itemCount == 0
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
                  color: Colors.deepPurple.shade50,
                  child: Text(
                    '${favorites.itemCount} Favorites',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favorites.itemCount,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final item = favorites.items[index];
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
                              context.read<FavoritesState>().removeItem(item);
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
                              'State is synchronized across all screens automatically!',
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
