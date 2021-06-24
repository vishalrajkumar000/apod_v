import 'package:apod_v/screens/apod_screen.dart';
import 'package:apod_v/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.dark().copyWith(
        primary: Colors.grey,
      )),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/apod': (context) => APODScreen(),
      },
    );
  }
}
