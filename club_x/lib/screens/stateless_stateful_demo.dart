import 'package:flutter/material.dart';
import 'animations_demo.dart';

/// Main demo screen combining both Stateless and Stateful widgets
/// This is a StatefulWidget because it manages the overall app state (theme mode)
class StatelessStatefulDemo extends StatefulWidget {
  const StatelessStatefulDemo({super.key});

  @override
  State<StatelessStatefulDemo> createState() => _StatelessStatefulDemoState();
}

class _StatelessStatefulDemoState extends State<StatelessStatefulDemo> {
  // State variable for theme mode
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stateless vs Stateful Widgets'),
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // STATELESS WIDGET SECTION
              const StaticHeader(
                title: 'Stateless Widgets',
                subtitle: 'Static UI components that never change',
                icon: Icons.lock,
                color: Colors.blue,
              ),

              const SizedBox(height: 16),

              // Examples of Stateless Widgets
              const StaticInfoCard(
                title: 'What is a StatelessWidget?',
                description:
                    'A widget that does not store any mutable state. '
                    'Once built, it remains unchanged until rebuilt by its parent. '
                    'Perfect for static content like labels, icons, and text.',
              ),

              const SizedBox(height: 12),

              const GreetingWidget(name: 'Flutter Developer'),

              const SizedBox(height: 12),

              const StaticFeatureRow(),

              const SizedBox(height: 32),

              // STATEFUL WIDGET SECTION
              const StaticHeader(
                title: 'Stateful Widgets',
                subtitle: 'Dynamic UI components that can change',
                icon: Icons.refresh,
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              const StaticInfoCard(
                title: 'What is a StatefulWidget?',
                description:
                    'A widget that maintains internal state that can change '
                    'during the app\'s lifecycle. It updates dynamically in response '
                    'to user actions, animations, or data changes.',
              ),

              const SizedBox(height: 16),

              // Examples of Stateful Widgets
              const InteractiveCounter(),

              const SizedBox(height: 16),

              const ColorChangerWidget(),

              const SizedBox(height: 16),

              const ToggleSwitchWidget(),

              const SizedBox(height: 16),

              const LikeButtonWidget(),

              const SizedBox(height: 16),

              const TextInputWidget(),

              const SizedBox(height: 32),

              // Comparison Section (Stateless)
              const ComparisonCard(),
              const SizedBox(height: 16),
              const AnimationsLinkCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STATELESS WIDGET EXAMPLES
// ============================================================================

/// Example 1: Static Header - StatelessWidget
/// This widget displays a section header that never changes
class StaticHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const StaticHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Example 2: Static Info Card - StatelessWidget
/// Displays information that doesn't change
class StaticInfoCard extends StatelessWidget {
  final String title;
  final String description;

  const StaticInfoCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 3: Greeting Widget - StatelessWidget
/// Simple stateless widget with a parameter
class GreetingWidget extends StatelessWidget {
  final String name;

  const GreetingWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.waving_hand, color: Colors.orange, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Hello, $name!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Text(
              'StatelessWidget',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 4: Static Feature Row - StatelessWidget
/// Displays static feature icons
class StaticFeatureRow extends StatelessWidget {
  const StaticFeatureRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            FeatureIcon(icon: Icons.star, label: 'Fast'),
            FeatureIcon(icon: Icons.security, label: 'Secure'),
            FeatureIcon(icon: Icons.device_hub, label: 'Scalable'),
          ],
        ),
      ),
    );
  }
}

/// Helper StatelessWidget for feature icons
class FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36, color: Colors.deepPurple),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// ============================================================================
// STATEFUL WIDGET EXAMPLES
// ============================================================================

/// Example 1: Interactive Counter - StatefulWidget
/// Classic counter that updates when button is pressed
class InteractiveCounter extends StatefulWidget {
  const InteractiveCounter({super.key});

  @override
  State<InteractiveCounter> createState() => _InteractiveCounterState();
}

class _InteractiveCounterState extends State<InteractiveCounter> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
      debugPrint('🔢 Counter incremented to: $_count');
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) {
        _count--;
        debugPrint('🔢 Counter decremented to: $_count');
      } else {
        debugPrint('⚠️ Counter cannot go below 0');
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      debugPrint('🔄 Counter reset to 0');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Interactive Counter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'StatefulWidget',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[200],
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_count',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrease'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Increase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 2: Color Changer - StatefulWidget
/// Changes color when button is tapped
class ColorChangerWidget extends StatefulWidget {
  const ColorChangerWidget({super.key});

  @override
  State<ColorChangerWidget> createState() => _ColorChangerWidgetState();
}

class _ColorChangerWidgetState extends State<ColorChangerWidget> {
  int _colorIndex = 0;
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  final List<String> _colorNames = [
    'Red',
    'Blue',
    'Green',
    'Orange',
    'Purple',
    'Teal',
  ];

  void _changeColor() {
    setState(() {
      _colorIndex = (_colorIndex + 1) % _colors.length;
      debugPrint('🎨 Color changed to: ${_colorNames[_colorIndex]}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Color Changer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'StatefulWidget',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 100,
              decoration: BoxDecoration(
                color: _colors[_colorIndex],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _colorNames[_colorIndex],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _changeColor,
              icon: const Icon(Icons.palette),
              label: const Text('Change Color'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _colors[_colorIndex],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 3: Toggle Switch - StatefulWidget
/// Shows on/off state with a switch
class ToggleSwitchWidget extends StatefulWidget {
  const ToggleSwitchWidget({super.key});

  @override
  State<ToggleSwitchWidget> createState() => _ToggleSwitchWidgetState();
}

class _ToggleSwitchWidgetState extends State<ToggleSwitchWidget> {
  bool _isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: _isEnabled ? Colors.green[50] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              _isEnabled ? Icons.toggle_on : Icons.toggle_off,
              size: 48,
              color: _isEnabled ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toggle Feature',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isEnabled ? 'Feature is ON' : 'Feature is OFF',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isEnabled ? Colors.green : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isEnabled,
              onChanged: (value) {
                setState(() {
                  _isEnabled = value;
                  debugPrint('🔘 Toggle switched to: ${value ? "ON" : "OFF"}');
                });
              },
              activeTrackColor: Colors.green,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Stateful',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 4: Like Button - StatefulWidget
/// Toggles between liked and unliked state
class LikeButtonWidget extends StatefulWidget {
  const LikeButtonWidget({super.key});

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  bool _isLiked = false;
  int _likeCount = 42;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Like Button Example',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_likeCount people liked this',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _toggleLike,
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.grey,
                size: 32,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Stateful',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 5: Text Input - StatefulWidget
/// Shows text as user types
class TextInputWidget extends StatefulWidget {
  const TextInputWidget({super.key});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  String _inputText = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.purple[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Real-time Text Input',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'StatefulWidget',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type something...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.text_fields, color: Colors.purple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _inputText.isEmpty
                          ? 'Your text will appear here...'
                          : 'You typed: "$_inputText"',
                      style: TextStyle(
                        fontSize: 14,
                        color: _inputText.isEmpty
                            ? Colors.grey[600]
                            : Colors.black87,
                        fontStyle: _inputText.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
                  if (_inputText.isNotEmpty)
                    Text(
                      '${_inputText.length} chars',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COMPARISON SECTION
// ============================================================================

/// Comparison Card - StatelessWidget
/// Static comparison information
class ComparisonCard extends StatelessWidget {
  const ComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.compare_arrows, size: 32, color: Colors.amber),
                SizedBox(width: 12),
                Text(
                  'Quick Comparison',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildComparisonRow(
              'State',
              'No mutable state',
              'Has mutable state',
            ),
            _buildComparisonRow(
              'Updates',
              'Rebuilt by parent',
              'Updates itself with setState()',
            ),
            _buildComparisonRow(
              'Use Case',
              'Static UI elements',
              'Interactive UI elements',
            ),
            _buildComparisonRow(
              'Performance',
              'Slightly faster',
              'Manages state overhead',
            ),
            _buildComparisonRow(
              'Examples',
              'Text, Icon, Image',
              'Buttons, Forms, Animations',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String aspect, String stateless, String stateful) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            aspect,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  child: Text(stateless, style: const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  child: Text(stateful, style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Link Card to open the Animations demo
class AnimationsLinkCard extends StatelessWidget {
  const AnimationsLinkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Animations & Transitions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try implicit and explicit animations, and custom page transitions in the dedicated demo screen.',
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AnimationsDemo(),
                  ),
                );
              },
              icon: const Icon(Icons.animation),
              label: const Text('Open Animations Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
