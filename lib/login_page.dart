import 'dart:convert';

import 'package:blogapp/dashboard_page.dart';
import 'package:blogapp/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
    LoginPage({Key key}) : super(key: key);
    
    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    bool obscureText = true ;
    TextEditingController _emailController,_passwordController;
    GlobalKey<ScaffoldState> _key = GlobalKey();
    bool isLoading = false ;
    @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
    @override
    Widget build(BuildContext context) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
        return Scaffold(
          key: _key,
          body: SingleChildScrollView(
            child: Container(
              color: Theme.of(context).primaryColor,
              height: height,
              width: width,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 60,),
                  Image.asset('images/logo.png',width: width/6,height: width/6,),
                  SizedBox(height: 20,),
                  Text('Blog App',style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 20,),
                  Card(
                    elevation: 10,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: 'Ex : example@gmail.com',
                              prefixIcon: Icon(Icons.mail)
                            ),
                            controller: _emailController,
                          ),
                          SizedBox(height: 20,),
                          TextField(
                            obscureText: obscureText,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: '***********',
                              prefixIcon: Icon(Icons.vpn_key),
                              suffixIcon: IconButton(
                                icon: Icon(obscureText?Icons.visibility:Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    obscureText = !obscureText ;
                                  });
                                },
                              )
                            ),
                          ),
                          SizedBox(height: 10,),
                          isLoading
                            ?CircularProgressIndicator()
                            :MaterialButton(
                            color: Theme.of(context).primaryColor,
                            child: Text('Login'),
                            onPressed: (){
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              
                              if(email.isEmpty){
                                _key.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Email is Empty'),
                                    backgroundColor: Colors.red,
                                  )
                                );
                              }else if(password.isEmpty){
                                _key.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Password is Empty'),
                                    backgroundColor: Colors.red,
                                  )
                                );
                              }else{
                                  setState(() {
                                    isLoading = true;
                                  });
                                  http.get('https://flutter.smarttersstudio.com/test/login.php?user=$email&pass=$password')
                                  .then((response) async {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ///Parse JSON Here
                                    
                                    String result = response.body;
                                    var jsonResult = json.decode(result);
                                    bool isSuccess = jsonResult ['result'];
                                    if(isSuccess){
                                      String id = jsonResult['id'];
                                      SharedPreferences s = await SharedPreferences.getInstance();
                                      await s.setString("user", id);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => DashboardPage()
                                        )
                                      );
                                    }else{
                                      String reason = jsonResult['reason'];
                                      _key.currentState.showSnackBar(
                                        SnackBar(
                                          content:Text(reason) ,
                                          backgroundColor: Colors.red,
                                        )
                                      );
                                    }
                                  });
                              }
                          }),
                          FlatButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpPage()));
                          }, child: Text('Sign up here'))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
    }
}
