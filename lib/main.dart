import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'HomePage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appBarColor = themeProvider.themeData.appBarTheme.backgroundColor;

    // Set the status bar color to match the AppBar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appBarColor, // Set status bar color
        statusBarIconBrightness: Brightness.light, // Adjust brightness based on the color
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      themeMode: ThemeMode.system, // Use system setting for theme mode
      home: YearInPixelsHomePage(),
    );
  }
}
