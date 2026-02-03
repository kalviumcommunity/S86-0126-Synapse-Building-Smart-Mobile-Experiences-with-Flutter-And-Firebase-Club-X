import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/responsive_home.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/widget_tree_demo.dart';
import 'screens/scrollable_views.dart';
import 'screens/user_input_form.dart';
import 'screens/state_management_demo.dart';
import 'screens/custom_widgets_demo.dart';
import 'screens/assets_demo_screen.dart';
import 'screens/animations_demo.dart';
import 'screens/auth_demo.dart';
import 'screens/firestore_demo.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const StatelessStatefulDemo(),
    ),
    GoRoute(
      path: '/responsive',
      name: 'responsive',
      builder: (context, state) => const ResponsiveHome(),
    ),
    GoRoute(
      path: '/widget-tree',
      name: 'widget-tree',
      builder: (context, state) => const WidgetTreeDemo(),
    ),
    GoRoute(
      path: '/scrollable-views',
      name: 'scrollable-views',
      builder: (context, state) => const ScrollableViews(),
    ),
    GoRoute(
      path: '/user-input-form',
      name: 'user-input-form',
      builder: (context, state) => const UserInputForm(),
    ),
    GoRoute(
      path: '/state-management',
      name: 'state-management',
      builder: (context, state) => const StateManagementDemo(),
    ),
    GoRoute(
      path: '/custom-widgets',
      name: 'custom-widgets',
      builder: (context, state) => const CustomWidgetsDemo(),
    ),
    GoRoute(
      path: '/assets-demo',
      name: 'assets-demo',
      builder: (context, state) => const AssetsDemoScreen(),
    ),
    // New demo routes for Firebase features
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthDemo(),
    ),
    GoRoute(
      path: '/firestore',
      name: 'firestore',
      builder: (context, state) => const FirestoreDemo(),
    ),
    GoRoute(
      path: '/animations',
      name: 'animations',
      builder: (context, state) => const AnimationsDemo(),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Debug log to trace app initialization
  debugPrint('🚀 Club-X App Starting...');
  debugPrint('📱 Firebase initialized and Flutter Application starting');

  runApp(const ClubXApp());

  debugPrint('✅ App Successfully Launched — Firebase initialized');
}

class ClubXApp extends StatelessWidget {
  const ClubXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Club X',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
