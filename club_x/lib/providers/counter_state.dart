import 'package:flutter/foundation.dart';

/// Counter state using Provider's ChangeNotifier
/// This class demonstrates basic state management with Provider
class CounterState with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // Notifies all listening widgets to rebuild
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}
