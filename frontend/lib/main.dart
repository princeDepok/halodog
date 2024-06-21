import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/sign_in.dart';
import 'package:frontend/screens/core/home.dart';
import 'package:frontend/screens/core/splash.dart';
// import 'package:frontend/screens/auth/sign_up.dart';
// import 'package:frontend/screens/core/doctors/list_doctors.dart';
// import 'package:frontend/screens/core/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignIn(),
    );
  }
}
