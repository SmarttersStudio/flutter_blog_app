import 'package:blogapp/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.green
      ),
      home: LoginPage(),
    );
  }
}


