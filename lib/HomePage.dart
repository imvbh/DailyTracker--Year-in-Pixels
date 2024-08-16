import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:year_in_pixels/theme/theme_provider.dart';
import 'Grid.dart';

class YearInPixelsHomePage extends StatefulWidget {
  @override
  _YearInPixelsHomePageState createState() => _YearInPixelsHomePageState();
}

class _YearInPixelsHomePageState extends State<YearInPixelsHomePage> {
  bool isPressed = false;
  

  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.background,
          statusBarIconBrightness: isPressed? Brightness.dark : Brightness.light,
          statusBarBrightness: isPressed? Brightness.light : Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pixel Diary',
              style: TextStyle(
                fontFamily: 'PixelifySans',
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 40,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isPressed = !isPressed;
                });
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              icon: isPressed
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
              color: Theme.of(context).colorScheme.inversePrimary,
              iconSize: 30,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: BoxDecoration(color: Colors.grey.shade300),
      //         child: const Text('Drawer Header'),
      //       ),
      //       ListTile(
      //         title: const Text('Edit Tags'),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: const Text('Select Year'),
      //         onTap: () {},
      //       ),
      //     ],
      //   ),
      // ),
      body: YearInPixelsGrid(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
