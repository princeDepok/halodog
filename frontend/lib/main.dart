import 'package:flutter/material.dart';
import 'package:frontend/screens/core/home.dart';
import 'package:frontend/screens/core/splash.dart';
import 'package:frontend/screens/more_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
