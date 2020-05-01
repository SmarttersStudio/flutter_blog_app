import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);
  
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obscureText = true ;
  TextEditingController _emailController,_passwordController,_nameController,_phoneController;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false ;
  String _nameError,
        _phoneError,
        _emailError,
        _passwordError;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
              SizedBox(height: 30,),
              Image.asset('images/logo.png',width: width/6,height: width/6,),
              SizedBox(height: 10,),
              Text('Blog App',style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
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
                          labelText: 'Name',
                          errorText: _nameError,
                          hintText: 'Ex : Guru',
                          prefixIcon: Icon(Icons.person)
                        ),
                        controller: _nameController,
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone',
                          errorText: _phoneError,
                          hintText: 'Ex : 9040302420',
                          prefixIcon: Icon(Icons.phone)
                        ),
                        controller: _phoneController,
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        decoration: InputDecoration(
                          errorText: _emailError,
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Ex : example@gmail.com',
                          prefixIcon: Icon(Icons.mail)
                        ),
                        controller: _emailController,
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        obscureText: obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          errorText: _passwordError,
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
                        child: Text('Signup'),
                        onPressed: (){
                          setState(() {
                            _nameError = null;
                            _phoneError = null ;
                            _emailError = null ;
                            _passwordError = null;
                          });
                          String name = _nameController.text;
                          String phone = _phoneController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          if(name.isEmpty){
                            setState(() {
                              _nameError = 'Name is Empty';
                            });
                          }else if(phone.isEmpty){
                            setState(() {
                              _phoneError = 'Phone is Empty';
                            });
                          } else if(email.isEmpty){
                            setState(() {
                              _emailError = 'Email is Empty';
                            });
                          }else if(password.isEmpty){
                            setState(() {
                              _passwordError = 'Password is Empty';
                            });
                          }else{
                            setState(() {
                              isLoading = true ;
                            });
                            http.get('https://flutter.smarttersstudio.com/test/signup.php?email=$email&password=$password&gender=1&name=$name&phone=$phone')
                              .then((response){
                              setState(() {
                                isLoading = false ;
                              });
                                var jsonResponse = json.decode(response.body);
                                if(jsonResponse['result']){
                                  _key.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Registered Successfully'),
                                      backgroundColor: Colors.green,
                                    )
                                  );
                                }else{
                                  _key.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(jsonResponse['reason']),
                                      backgroundColor: Colors.red,
                                    )
                                  );
                                  
                                }
                            });
                          }
                        }),
                      FlatButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text('Login here'))
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
