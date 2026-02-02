import 'package:flutter/material.dart';

/// Demo screen showcasing MediaQuery and LayoutBuilder concepts
class ResponsiveDemoScreen extends StatelessWidget {
  const ResponsiveDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery usage examples
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Design Demo')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adaptive layout based on width
          if (screenWidth < 600) {
            // Mobile layout
            return _buildMobileLayout(context, screenWidth, screenHeight);
          } else {
            // Tablet layout
            return _buildTabletLayout(context, screenWidth, screenHeight);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, double width, double height) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: width * 0.9,
            height: height * 0.15,
            color: Colors.tealAccent,
            child: const Center(
              child: Text('Mobile View', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoBox('Screen Width', '${width.toStringAsFixed(0)} px'),
          _buildInfoBox('Screen Height', '${height.toStringAsFixed(0)} px'),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: 200,
              color: Colors.orangeAccent,
              child: const Center(child: Text('Left Panel')),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 200,
              color: Colors.tealAccent,
              child: const Center(child: Text('Right Panel')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value),
          ],
        ),
      ),
    );
  }
}
