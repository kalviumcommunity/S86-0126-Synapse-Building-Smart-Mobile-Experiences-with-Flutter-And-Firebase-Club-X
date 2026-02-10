import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod Counter Provider
/// Simple state provider for counter functionality
final counterProvider = StateProvider<int>((ref) => 0);

/// Riverpod Favorites Provider
/// StateNotifier for more complex state management
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>(
  (ref) => FavoritesNotifier(),
);

/// FavoritesNotifier - Manages favorites list state with Riverpod
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]);

  void addItem(String item) {
    if (!state.contains(item)) {
      state = [...state, item]; // Immutable update
    }
  }

  void removeItem(String item) {
    state = state.where((i) => i != item).toList();
  }

  void toggleFavorite(String item) {
    if (state.contains(item)) {
      removeItem(item);
    } else {
      addItem(item);
    }
  }

  bool isFavorite(String item) {
    return state.contains(item);
  }

  void clearAll() {
    state = [];
  }
}

/// Computed provider - demonstrates derived state
final favoritesCountProvider = Provider<int>((ref) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.length;
});
