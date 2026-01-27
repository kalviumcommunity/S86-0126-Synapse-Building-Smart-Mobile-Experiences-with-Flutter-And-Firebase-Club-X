import 'package:flutter/material.dart';

/// A comprehensive demo screen showcasing Flutter's Widget Tree and Reactive UI Model
/// This screen demonstrates:
/// 1. Widget hierarchy and nesting
/// 2. Reactive UI using setState()
/// 3. Multiple interactive state changes
/// 4. Parent-child widget relationships
class WidgetTreeDemo extends StatefulWidget {
  const WidgetTreeDemo({super.key});

  @override
  State<WidgetTreeDemo> createState() => _WidgetTreeDemoState();
}

class _WidgetTreeDemoState extends State<WidgetTreeDemo> {
  // State variables - changes to these will trigger UI rebuilds
  int _counter = 0;
  Color _backgroundColor = Colors.white;
  bool _isProfileVisible = true;
  String _statusMessage = 'Welcome to Club-X!';
  double _sliderValue = 50.0;
  
  // List of colors for background cycling
  final List<Color> _colorOptions = [
    Colors.white,
    Colors.blue[50]!,
    Colors.green[50]!,
    Colors.orange[50]!,
    Colors.purple[50]!,
  ];
  int _currentColorIndex = 0;

  /// Increments the counter - demonstrates simple state change
  void _incrementCounter() {
    setState(() {
      _counter++;
      _statusMessage = 'Counter incremented to $_counter!';
    });
  }

  /// Decrements the counter - demonstrates state validation
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _statusMessage = 'Counter decremented to $_counter!';
      } else {
        _statusMessage = 'Counter cannot go below zero!';
      }
    });
  }

  /// Resets the counter - demonstrates multiple state changes at once
  void _resetCounter() {
    setState(() {
      _counter = 0;
      _statusMessage = 'Counter has been reset!';
    });
  }

  /// Cycles through background colors - demonstrates color state management
  void _changeBackgroundColor() {
    setState(() {
      _currentColorIndex = (_currentColorIndex + 1) % _colorOptions.length;
      _backgroundColor = _colorOptions[_currentColorIndex];
      _statusMessage = 'Background color changed!';
    });
  }

  /// Toggles profile card visibility - demonstrates conditional rendering
  void _toggleProfileVisibility() {
    setState(() {
      _isProfileVisible = !_isProfileVisible;
      _statusMessage = _isProfileVisible 
          ? 'Profile card is now visible' 
          : 'Profile card is now hidden';
    });
  }

  /// Updates slider value - demonstrates continuous state updates
  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      _statusMessage = 'Slider value: ${value.toInt()}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Root of the widget tree for this screen
    return Scaffold(
      // AppBar - First child of Scaffold
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Widget Tree & Reactive UI Demo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Action button in AppBar
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),

      // Body - Second child of Scaffold, contains main content
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: _backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Message Card - Shows reactive updates
              _buildStatusCard(),
              
              const SizedBox(height: 20),
              
              // Counter Section - Demonstrates setState() with numbers
              _buildCounterSection(),
              
              const SizedBox(height: 20),
              
              // Interactive Controls Section
              _buildInteractiveControlsSection(),
              
              const SizedBox(height: 20),
              
              // Conditional Profile Card - Shows/hides based on state
              if (_isProfileVisible) _buildProfileCard(),
              
              const SizedBox(height: 20),
              
              // Slider Section - Continuous state updates
              _buildSliderSection(),
              
              const SizedBox(height: 20),
              
              // Widget Tree Visualization Card
              _buildWidgetTreeVisualization(),
            ],
          ),
        ),
      ),

      // FloatingActionButton - Third child of Scaffold
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
      ),
    );
  }

  /// Builds the status message card showing current state
  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.deepPurple[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.notifications_active,
              color: Colors.deepPurple,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _statusMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the counter section with increment/decrement buttons
  Widget _buildCounterSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Interactive Counter',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Display counter value with animation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[900],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Control buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Decrement button
                ElevatedButton.icon(
                  onPressed: _decrementCounter,
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrease'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                
                // Reset button
                ElevatedButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                
                // Increment button
                ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('Increase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the interactive controls section
  Widget _buildInteractiveControlsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'UI Control Panel',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Change background color button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _changeBackgroundColor,
                icon: const Icon(Icons.color_lens),
                label: const Text('Change Background Color'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Toggle profile visibility button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _toggleProfileVisibility,
                icon: Icon(_isProfileVisible ? Icons.visibility_off : Icons.visibility),
                label: Text(_isProfileVisible ? 'Hide Profile Card' : 'Show Profile Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the profile card (conditionally rendered)
  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Text(
                'CX',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Profile information
            const Text(
              'Club-X Member',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Profile interactions: $_counter',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Profile details in a grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProfileStat('Posts', '${_counter * 3}'),
                _buildProfileStat('Followers', '${_counter * 10}'),
                _buildProfileStat('Following', '${_counter * 5}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build profile statistics
  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Builds the slider section for continuous value updates
  Widget _buildSliderSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dynamic Value Control',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Value: ${_sliderValue.toInt()}%',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Slider widget
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.deepPurple[100],
              label: '${_sliderValue.toInt()}%',
              onChanged: _onSliderChanged,
            ),
            
            const SizedBox(height: 16),
            
            // Visual representation of slider value
            LinearProgressIndicator(
              value: _sliderValue / 100,
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              color: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a visualization of the widget tree structure
  Widget _buildWidgetTreeVisualization() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget Tree Structure',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Widget tree visualization
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!, width: 2),
              ),
              child: const Text(
                'MaterialApp\n'
                ' └─ Scaffold\n'
                '     ├─ AppBar\n'
                '     │   ├─ Text (Title)\n'
                '     │   └─ IconButton (Info)\n'
                '     ├─ Body (AnimatedContainer)\n'
                '     │   └─ SingleChildScrollView\n'
                '     │       └─ Column\n'
                '     │           ├─ Card (Status)\n'
                '     │           │   └─ Row\n'
                '     │           │       ├─ Icon\n'
                '     │           │       └─ Text\n'
                '     │           ├─ Card (Counter)\n'
                '     │           │   └─ Column\n'
                '     │           │       ├─ Text (Title)\n'
                '     │           │       ├─ Container (Counter Display)\n'
                '     │           │       └─ Row (Buttons)\n'
                '     │           ├─ Card (Controls)\n'
                '     │           │   └─ Column\n'
                '     │           │       └─ ElevatedButtons\n'
                '     │           ├─ Card (Profile - Conditional)\n'
                '     │           │   └─ Column\n'
                '     │           │       ├─ CircleAvatar\n'
                '     │           │       ├─ Text (Name)\n'
                '     │           │       └─ Row (Stats)\n'
                '     │           ├─ Card (Slider)\n'
                '     │           │   └─ Column\n'
                '     │           │       ├─ Text\n'
                '     │           │       ├─ Slider\n'
                '     │           │       └─ LinearProgressIndicator\n'
                '     │           └─ Card (Tree Visualization)\n'
                '     └─ FloatingActionButton',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'This tree shows the hierarchical structure of widgets in this screen. '
              'Each node represents a widget, and indentation shows parent-child relationships.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows an informational dialog explaining the reactive UI model
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Reactive UI Model',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'How Flutter\'s Reactive UI Works:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoPoint(
                  '1. State Variables',
                  'Variables like _counter, _backgroundColor store the current state.',
                ),
                _buildInfoPoint(
                  '2. setState()',
                  'When you call setState(), Flutter knows to rebuild the widget.',
                ),
                _buildInfoPoint(
                  '3. Automatic Rebuild',
                  'Only the affected parts of the UI are rebuilt, not the entire screen.',
                ),
                _buildInfoPoint(
                  '4. Efficient Updates',
                  'Flutter compares the old and new widget trees and updates only what changed.',
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Try interacting with the buttons, slider, and controls to see the reactive UI in action!',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  /// Helper method to build info points in dialog
  Widget _buildInfoPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
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
