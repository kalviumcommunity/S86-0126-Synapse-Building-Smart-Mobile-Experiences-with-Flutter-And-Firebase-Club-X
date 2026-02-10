import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/counter_state.dart';
import 'providers/favorites_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Wrap with ProviderScope for Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap with MultiProvider for Provider state management
    return MultiProvider(
      providers: [
        // Register CounterState for Provider counter demo
        ChangeNotifierProvider(create: (_) => CounterState()),
        // Register FavoritesState for Provider multi-screen demo
        ChangeNotifierProvider(create: (_) => FavoritesState()),
      ],
      child: MaterialApp(
        title: 'Auth Flow Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            // Show splash screen while checking auth state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            
            // If user is logged in, show HomeScreen (Auto-Login)
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            
            // If user is not logged in, show AuthScreen
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
