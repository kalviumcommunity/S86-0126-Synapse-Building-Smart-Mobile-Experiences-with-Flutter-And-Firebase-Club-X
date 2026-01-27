import 'package:flutter/material.dart';
import 'screens/stateless_stateful_demo.dart';

void main() {
  // Debug log to trace app initialization
  debugPrint('🚀 Club-X App Starting...');
  debugPrint('📱 Initializing Flutter Application');
  
  runApp(const StatelessStatefulDemo());
  
  debugPrint('✅ App Successfully Launched');
}
