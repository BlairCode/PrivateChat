import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:private_chat/widgets/chat_screen.dart';
import 'package:private_chat/utils/cleanup.dart';

/// Entry point of the application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager()
      .initialize(callbackDispatcher, isInDebugMode: true)
      .then((_) {
        Workmanager().registerPeriodicTask(
          "dailyCleanup",
          "deleteMessages",
          frequency: const Duration(hours: 24), // Daily cleanup in production
          initialDelay: _calculateInitialDelay(),
        );
      })
      .catchError((e) {
        print(
          "Workmanager initialization failed: $e",
        ); // Replace with logging in production
      });
  runApp(const PrivateChatApp());
}

/// Calculates the delay until the next midnight.
Duration _calculateInitialDelay() {
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day + 1);
  return midnight.difference(now);
}

/// Main application widget defining the app's theme and home screen.
class PrivateChatApp extends StatelessWidget {
  const PrivateChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Chat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
        appBarTheme: const AppBarTheme(
          elevation: 3,
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[300],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      home: const ChatScreen(),
    );
  }
}
