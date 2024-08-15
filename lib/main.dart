import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        // Light theme settings
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // Dark theme settings
      ),
      themeMode: ThemeMode.system, // This will use the device's theme setting
      home: YearInPixelsHomePage(),
    );
  }
}
