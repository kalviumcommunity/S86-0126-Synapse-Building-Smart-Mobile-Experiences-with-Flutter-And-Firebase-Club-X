import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/riverpod_providers.dart';

/// Riverpod Counter Demo Screen
/// Demonstrates:
/// - Using StateProvider
/// - Reading state with ref.watch()
/// - Updating state with ref.read()
/// - More type-safe and testable approach
class RiverpodDemoScreen extends ConsumerWidget {
  const RiverpodDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch() - Listens to provider and rebuilds on changes
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Demo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.rocket_launch,
              size: 80,
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              '$count',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'riv_decrement',
                  onPressed: () {
                    // ref.read() - Accesses provider without listening
                    ref.read(counterProvider.notifier).state--;
                  },
                  tooltip: 'Decrement',
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'riv_reset',
                  onPressed: () {
                    ref.read(counterProvider.notifier).state = 0;
                  },
                  tooltip: 'Reset',
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'riv_increment',
                  onPressed: () {
                    ref.read(counterProvider.notifier).state++;
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
              color: Colors.teal,
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
                          'How Riverpod Works',
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
                      '• ref.watch() - Listens and rebuilds on changes\n'
                      '• ref.read() - Accesses without rebuilding\n'
                      '• StateProvider - For simple state\n'
                      '• StateNotifier - For complex state\n'
                      '• Immutable updates - state = newValue\n'
                      '• No BuildContext needed - more testable',
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
