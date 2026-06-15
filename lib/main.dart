import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskhub/screens/setting_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required

  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp(this.isLoggedIn, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskHub',
      theme: ThemeData.dark(useMaterial3: true),

      // THIS LINE FIXES YOUR PROBLEM
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),

      routes: {
        '/home': (_) => const HomeScreen(),
        '/add-task': (_) => const AddTaskScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
