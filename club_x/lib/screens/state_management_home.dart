import 'package:flutter/material.dart';
import 'provider_demo_screen.dart';
import 'riverpod_demo_screen.dart';
import 'provider_favorites_screen.dart';
import 'riverpod_favorites_screen.dart';

/// State Management Home Screen
/// Central hub for all state management examples
class StateManagementHomeScreen extends StatelessWidget {
  const StateManagementHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Examples'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Card(
              color: Colors.indigo,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.settings, size: 60, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Scalable State Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Provider vs Riverpod Examples',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Provider Section
            const Text(
              '📦 Provider Examples',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDemoCard(
              context,
              title: 'Provider Counter Demo',
              subtitle: 'Basic state management with ChangeNotifier',
              icon: Icons.touch_app,
              color: Colors.deepPurple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProviderDemoScreen(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildDemoCard(
              context,
              title: 'Provider Multi-Screen Demo',
              subtitle: 'Shared state across multiple screens',
              icon: Icons.favorite,
              color: Colors.deepPurple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProviderFavoritesScreen(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Riverpod Section
            const Text(
              '🚀 Riverpod Examples',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDemoCard(
              context,
              title: 'Riverpod Counter Demo',
              subtitle: 'Advanced state management with immutability',
              icon: Icons.rocket_launch,
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RiverpodDemoScreen(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildDemoCard(
              context,
              title: 'Riverpod Multi-Screen Demo',
              subtitle: 'Immutable shared state with StateNotifier',
              icon: Icons.favorite,
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RiverpodFavoritesScreen(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Comparison Card
            Card(
              color: Colors.amber.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.compare_arrows, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Provider vs Riverpod',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Provider:\n'
                      '✓ Easier for beginners\n'
                      '✓ Uses BuildContext\n'
                      '✓ Mutable state with notifyListeners()\n\n'
                      'Riverpod:\n'
                      '✓ More advanced and scalable\n'
                      '✓ No BuildContext needed\n'
                      '✓ Immutable state updates\n'
                      '✓ Better for testing\n'
                      '✓ Compile-time safety',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Key Benefits Card
            Card(
              color: Colors.green.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Why Use State Management?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '✓ Eliminates prop-drilling\n'
                      '✓ Automatic UI updates on data changes\n'
                      '✓ Clean separation of UI and logic\n'
                      '✓ Essential for large applications\n'
                      '✓ Improved testability\n'
                      '✓ Better code organization',
                      style: TextStyle(fontSize: 14),
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

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
