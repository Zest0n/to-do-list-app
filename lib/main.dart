import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// Every Flutter app starts by running this function.
void main() {
  runApp(const MyApp());
}

// MyApp sets up the overall app: its title, theme, and starting screen.
// It is "Stateless" because this widget itself never changes once built —
// all the changing data (the task list) lives inside HomeScreen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
