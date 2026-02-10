import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_state.dart';

/// Provider Counter Demo Screen
/// Demonstrates:
/// - Using ChangeNotifierProvider
/// - Reading state with context.watch()
/// - Updating state with context.read()
class ProviderDemoScreen extends StatelessWidget {
  const ProviderDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch() - Listens to changes and rebuilds widget
    final counter = context.watch<CounterState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.touch_app,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              '${counter.count}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'decrement',
                  onPressed: () {
                    // context.read() - Accesses provider without listening
                    context.read<CounterState>().decrement();
                  },
                  tooltip: 'Decrement',
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: () {
                    context.read<CounterState>().reset();
                  },
                  tooltip: 'Reset',
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'increment',
                  onPressed: () {
                    context.read<CounterState>().increment();
                  },
                  tooltip: 'Increment',
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Card(
              margin: EdgeInsets.all(16),
              color: Colors.deepPurple,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'How Provider Works',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• context.watch<T>() - Listens and rebuilds on changes\n'
                      '• context.read<T>() - Accesses without rebuilding\n'
                      '• notifyListeners() - Triggers UI updates\n'
                      '• ChangeNotifier - Base class for state objects',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
