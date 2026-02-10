import 'package:flutter/foundation.dart';

/// Favorites state for multi-screen shared state example
/// Demonstrates how state can be shared and updated across multiple screens
class FavoritesState with ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  bool isFavorite(String item) {
    return _items.contains(item);
  }

  void addItem(String item) {
    if (!_items.contains(item)) {
      _items.add(item);
      notifyListeners();
    }
  }

  void removeItem(String item) {
    _items.remove(item);
    notifyListeners();
  }

  void toggleFavorite(String item) {
    if (isFavorite(item)) {
      removeItem(item);
    } else {
      addItem(item);
    }
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }
}
