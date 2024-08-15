import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Grid.dart'; 

class YearInPixelsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Color.fromARGB(255, 255, 246, 246),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        
        title: const Text(
          'Daily Pixels',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: const Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Edit Tags'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Select Year'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: YearInPixelsGrid(),
      backgroundColor: Colors.white,
    );
  }
}
