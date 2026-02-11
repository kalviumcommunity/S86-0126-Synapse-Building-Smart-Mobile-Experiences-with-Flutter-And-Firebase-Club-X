# Assignment 3.46: Creating Themed UIs Using Dark Mode and Dynamic Colors

## 📚 Assignment Overview

This assignment focuses on implementing modern theming capabilities in Flutter applications. You'll learn to enable dark mode, create custom light/dark themes, toggle themes dynamically at runtime, and optionally persist theme preferences for a polished user experience.

## 🎯 Learning Objectives

By completing this assignment, you will be able to:

- [ ] Understand the importance of theming in modern mobile apps
- [ ] Set up basic light and dark themes in MaterialApp
- [ ] Create custom color schemes and typography for different themes
- [ ] Implement dynamic theme switching using state management (Provider/Riverpod)
- [ ] Build theme toggle UI components
- [ ] Persist theme selection using SharedPreferences
- [ ] Implement Material 3 dynamic colors (Material You)
- [ ] Handle common theming issues and edge cases
- [ ] Follow theming best practices

## 📖 Concept Summary

### Why Theming Matters

Modern apps must support diverse user preferences and environmental conditions:

- **User Experience** - Enhance readability and reduce eye strain
- **Accessibility** - Better contrast and visibility in various lighting conditions
- **Battery Efficiency** - Dark mode reduces power consumption on OLED screens
- **Brand Consistency** - Unified visual identity across the entire app
- **Polish & Professionalism** - Shows attention to detail and quality

### Core Concepts

#### 1. **ThemeData Structure**
```dart
ThemeData(
  brightness: Brightness.light,        // Light or dark
  primaryColor: Colors.blue,            // Primary color
  scaffoldBackgroundColor: Colors.white, // Background
  appBarTheme: AppBarTheme(...),       // AppBar styling
  textTheme: TextTheme(...),           // Typography
  // ... more customizations
)
```

#### 2. **ThemeMode Options**
- `ThemeMode.system` - Follows device settings
- `ThemeMode.light` - Force light mode
- `ThemeMode.dark` - Force dark mode

#### 3. **Theme Switching**
Use state management to toggle themes dynamically without restarting the app.

#### 4. **Material 3 (Material You)**
Dynamic color adaptation based on device wallpaper and system palette.

## 🛠️ Assignment Requirements

### Part 1: Basic Theme Setup (Mandatory)

Create a `theme_config.dart` file with:

1. **Light Theme**
   - Primary color: Blue
   - Background: White
   - Custom AppBar styling
   - Custom text themes

2. **Dark Theme**
   - Primary color: Teal
   - Background: Black/Dark gray
   - Custom AppBar styling with accent colors
   - Consistent text contrast

3. **Apply Themes in MaterialApp**
   - Set `theme` property for light mode
   - Set `darkTheme` property for dark mode
   - Set `themeMode` to `ThemeMode.system`

### Part 2: Dynamic Theme Switching (Mandatory)

1. **Create ThemeState Provider/Class**
   - Use Provider or Riverpod for state management
   - Implement toggle method
   - Notify listeners on change

2. **Build Theme Toggle UI**
   - Add Switch or SegmentedButton in settings
   - Toggle between light/dark themes
   - Show current theme status

3. **Widget Updates**
   - Use `Theme.of(context)` instead of hardcoded colors
   - Update custom widgets to respect theme

### Part 3: Theme Persistence (Optional - Extra Credit)

1. **Save Theme Preference**
   - Use SharedPreferences to persist selection
   - Save on theme change

2. **Load Saved Theme**
   - Retrieve on app startup
   - Apply saved theme preference

### Part 4: Material 3 & Dynamic Colors (Optional - Extra Credit)

1. **Enable Material 3**
   - Set `useMaterial3: true` in ThemeData

2. **Implement ColorScheme.fromSeed()**
   - Create dynamic color schemes from seed colors
   - Adapt to device wallpaper

## 📝 Implementation Checklist

### Required Files to Create/Modify

- [ ] `lib/config/theme_config.dart` - Define light and dark themes
- [ ] `lib/providers/theme_provider.dart` - Theme state management
- [ ] `lib/screens/settings_screen.dart` - Theme toggle UI (or update existing)
- [ ] `lib/main.dart` - Apply themes to MaterialApp
- [ ] Update all custom widgets to use `Theme.of(context)`

### Code Quality Requirements

- [ ] No hardcoded colors in widgets (use `Theme.of(context)`)
- [ ] Proper null safety throughout
- [ ] Consistent naming conventions
- [ ] Comprehensive code comments
- [ ] Handle system theme changes gracefully

## 🚀 Getting Started

### Step 1: Create Theme Configuration
```dart
// lib/config/theme_config.dart

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  // ... more configuration
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.teal,
  // ... more configuration
);
```

### Step 2: Set Up State Management
```dart
// lib/providers/theme_provider.dart

class ThemeState with ChangeNotifier {
  ThemeMode mode = ThemeMode.system;

  void toggleTheme(bool isDark) {
    mode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
```

### Step 3: Apply in MaterialApp
```dart
// lib/main.dart

MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: context.watch<ThemeState>().mode,
  home: const HomeScreen(),
);
```

### Step 4: Add Theme Toggle
```dart
Switch(
  value: context.watch<ThemeState>().mode == ThemeMode.dark,
  onChanged: (value) {
    context.read<ThemeState>().toggleTheme(value);
  },
)
```

## ⚠️ Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Theme doesn't update | Missing `notifyListeners()` | Ensure provider notifies on change |
| UI flickers on toggle | Heavy rebuilds | Move theme state to root, use `watch()` |
| Dark theme inconsistent | Hardcoded colors in widgets | Use `Theme.of(context)` everywhere |
| Persistence fails | Wrong SharedPreferences usage | Ensure async init before `runApp()` |
| Colors don't match design | Missing color scheme customization | Define complete `ColorScheme` in ThemeData |

## 📚 Best Practices

1. **Never Hardcode Colors**
   - Always use `Theme.of(context).colorScheme` or `Theme.of(context).primaryColor`
   - Makes themes work consistently across the app

2. **Separate Theme Files**
   - Keep light and dark themes in separate functions or classes
   - Makes maintenance easier

3. **Use Material 3**
   - Modern design system with better color harmony
   - Enable with `useMaterial3: true`

4. **Test Both Themes**
   - Manually test light mode
   - Manually test dark mode
   - Check all screens and widgets

5. **Provide User Control**
   - Don't force themes on users
   - Always offer toggle in settings
   - Remember their preference

6. **Handle System Changes**
   - Gracefully respond to system theme changes
   - Don't override user preference unnecessarily

## 📦 Required Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0          # or riverpod: ^2.0.0
  shared_preferences: ^2.0.0 # For persistence
```

Install with:
```bash
flutter pub get
```

## 🔗 Resources

- [Flutter Theming Documentation](https://docs.flutter.dev/ui/themes)
- [Material 3 Design Guide](https://m3.material.io/)
- [Provider Package](https://pub.dev/packages/provider)
- [Riverpod Package](https://pub.dev/packages/riverpod)
- [SharedPreferences Package](https://pub.dev/packages/shared_preferences)
- [Dynamic Color Package](https://pub.dev/packages/dynamic_color)

## ✅ Submission Checklist

Before submitting, verify:

- [ ] Light theme is fully implemented and styled
- [ ] Dark theme is fully implemented and styled
- [ ] Theme toggle works without restarting app
- [ ] All widgets use `Theme.of(context)` instead of hardcoded colors
- [ ] No compilation errors or warnings
- [ ] Code is well-commented and formatted
- [ ] Tested on both light and dark modes
- [ ] (Optional) Theme preference persists across app restarts
- [ ] (Optional) Material 3 dynamic colors implemented
- [ ] README is updated with implementation details

## 🎯 Scoring Rubric

| Criteria | Points |
|----------|--------|
| Basic Theme Setup (Light/Dark) | 15 |
| Theme Switching Implementation | 15 |
| Code Quality & Best Practices | 15 |
| Widget Theme Integration | 15 |
| UI/UX Polish | 10 |
| Theme Persistence (Optional) | 10 |
| Material 3 Implementation (Optional) | 10 |
| Documentation & Comments | 10 |
| **Total** | **100** |

## 📞 Support

If you encounter issues:

1. Review the troubleshooting section above
2. Check the Flutter documentation links
3. Verify all dependencies are installed
4. Test with `flutter clean` && `flutter pub get`

---

**Target Score:** 60% or more  
**Time Limit:** 180 minutes  
**Difficulty:** Intermediate

Good luck! 🚀
