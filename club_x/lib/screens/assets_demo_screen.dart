import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Demo screen showcasing images, icons, and asset management in Flutter
class AssetsDemoScreen extends StatelessWidget {
  const AssetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets & Icons Demo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            _buildHeaderSection(),
            const SizedBox(height: 24),

            // Material Icons Section
            _buildMaterialIconsSection(),
            const SizedBox(height: 24),

            // Cupertino Icons Section
            _buildCupertinoIconsSection(),
            const SizedBox(height: 24),

            // Icon Grid Section
            _buildIconGridSection(),
            const SizedBox(height: 24),

            // App Features with Icons
            _buildFeaturesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // App Icon Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.flutter_dash,
                size: 60,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Club-X Flutter App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Powered by Flutter Framework',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialIconsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Material Icons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconColumn(Icons.home, 'Home', Colors.blue),
                _buildIconColumn(Icons.favorite, 'Favorite', Colors.red),
                _buildIconColumn(Icons.star, 'Star', Colors.amber),
                _buildIconColumn(Icons.person, 'Profile', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoIconsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cupertino Icons (iOS Style)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconColumn(
                  CupertinoIcons.heart_fill,
                  'Heart',
                  Colors.pink,
                ),
                _buildIconColumn(
                  CupertinoIcons.star_fill,
                  'Star',
                  Colors.orange,
                ),
                _buildIconColumn(
                  CupertinoIcons.bell_fill,
                  'Bell',
                  Colors.purple,
                ),
                _buildIconColumn(
                  CupertinoIcons.settings,
                  'Settings',
                  Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconColumn(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildIconGridSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Platform Icons',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlatformIcon(Icons.android, 'Android', Colors.green),
                _buildPlatformIcon(Icons.apple, 'iOS', Colors.grey),
                _buildPlatformIcon(Icons.web, 'Web', Colors.blue),
                _buildPlatformIcon(Icons.desktop_windows, 'Desktop', Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(IconData icon, String name, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, size: 32, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.photo_library,
              'Image Management',
              'Load and display local images efficiently',
            ),
            _buildFeatureItem(
              Icons.palette,
              'Icon Library',
              'Access 1000+ Material and Cupertino icons',
            ),
            _buildFeatureItem(
              Icons.folder_open,
              'Asset Organization',
              'Structured folder system for all resources',
            ),
            _buildFeatureItem(
              Icons.speed,
              'Performance',
              'Optimized asset loading for fast rendering',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.deepPurple),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
