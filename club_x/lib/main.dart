import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/responsive_home.dart';
import 'screens/stateless_stateful_demo.dart';
import 'screens/widget_tree_demo.dart';
import 'screens/scrollable_views.dart';
import 'screens/user_input_form.dart';
import 'screens/state_management_demo.dart';
import 'screens/custom_widgets_demo.dart';

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
  ],
);

void main() {
  // Debug log to trace app initialization
  debugPrint('🚀 Club-X App Starting...');
  debugPrint('📱 Initializing Flutter Application');

  runApp(const ClubXApp());

  debugPrint('✅ App Successfully Launched');
}

class ClubXApp extends StatelessWidget {
  const ClubXApp({Key? key}) : super(key: key);

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
