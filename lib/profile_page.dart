import 'dart:convert';

import 'package:blogapp/my_post_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
    @override
    _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: FutureBuilder<String>(
            future: getProfileFromServer(),
            builder:(context,snapshot){
              if(snapshot.hasData){
                String data = snapshot.data!;
                var jsonData = json.decode(data);
                String name = jsonData['name'];
                String mobile = jsonData['phone'];
                String email = jsonData['email'];
                String gender = jsonData['gender'];
                return getProfile(
                  name: name,
                  mobile: mobile,
                  email: email,
                  gender: gender
                );
              }else{
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            } )
        );
    }
    Future<String> getProfileFromServer() async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? id = preferences.getString("user");
      var response = await http.get(Uri.parse('https://flutter.smarttersstudio.com/test/profile.php?id=$id'));
      return response.body;
    }
    
    getProfile({required String name,required String mobile,required String email,required String gender}){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 40,
              child: Text(name.substring(0,1),style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text(name),
                    SizedBox(
                      height: 5,
                    ),
                    Text(email),
                    SizedBox(
                      height: 5,
                    ),
                    Text(mobile),
                    SizedBox(
                      height: 5,
                    ),
                    Text(gender=='1'?'male':'Female')
                  ],
                ),
              ),
            ),
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyPostPage()));
            },child: Text('View My Posts'),)
          ],
        ),
      );
    }
}
