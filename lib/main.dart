import 'package:blogapp/dashboard_page.dart';
import 'package:blogapp/login_page.dart';
import 'package:blogapp/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: FutureBuilder<bool>(
        builder: (context , snapshot){
          if(snapshot.hasData){
            if(snapshot.data==true){
              return DashboardPage();
            }else{
              return LoginPage();
            }
          }else{
            return SplashPage();
          }
        },future: isLoggedIn(),
      ),
    );
  }
  
  Future<bool> isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString("user");
    if(user==null)
      return false;
    else
      return true;
  }
}


