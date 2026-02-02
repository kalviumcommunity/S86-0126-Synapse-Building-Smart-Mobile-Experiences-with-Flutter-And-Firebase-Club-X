import 'package:flutter/material.dart';

class AnimationsDemo extends StatefulWidget {
  const AnimationsDemo({Key? key}) : super(key: key);

  @override
  State<AnimationsDemo> createState() => _AnimationsDemoState();
}

class _AnimationsDemoState extends State<AnimationsDemo>
    with SingleTickerProviderStateMixin {
  // For implicit animations
  bool _logoVisible = true;

  // For explicit animation (rotation)
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleLogoVisibility() {
    setState(() {
      _logoVisible = !_logoVisible;
    });
  }

  void _openDetailsWithTransition() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DetailsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from right + fade combined using Tween and CurvedAnimation
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );
          final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: opacityAnimation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations & Transitions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Implicit Animation: AnimatedOpacity'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    AnimatedOpacity(
                      opacity: _logoVisible ? 1.0 : 0.15,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: const FlutterLogo(size: 120),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _toggleLogoVisibility,
                      icon: const Icon(Icons.visibility),
                      label: const Text('Toggle Visibility'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Explicit Animation: RotationTransition'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    RotationTransition(
                      turns: _rotationController,
                      child: const FlutterLogo(size: 100),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Continuous rotation using AnimationController',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Page Transition: Slide + Fade'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text(
                      'Tap the button to open a new page with a smooth slide+fade transition.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _openDetailsWithTransition,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open Details Page'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Tips & Best Practices'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '• Keep animations short (200–700 ms) for responsiveness.',
                    ),
                    Text(
                      '• Use Curves.easeInOut or Curves.fastOutSlowIn for natural motion.',
                    ),
                    Text(
                      '• Test on multiple devices for performance and smoothness.',
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

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 140),
              const SizedBox(height: 24),
              const Text(
                'This page was opened with a custom PageRouteBuilder transition.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
