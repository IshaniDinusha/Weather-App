import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        textTheme: Theme
            .of(context)
            .textTheme
            .apply(
          bodyColor: Colors.white,
          displayColor: Colors.blueGrey,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }


}



