import 'package:blogapp/PostData.dart';
import 'package:blogapp/login_page.dart';
import 'package:blogapp/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class DashboardPage extends StatefulWidget {
    @override
    _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Blog App'),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.person), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
              }),
              IconButton(icon: Icon(Icons.power_settings_new), onPressed: () async{
                SharedPreferences preferences = await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              })
            ],
          ),
          body: FutureBuilder< List<PostData> >(
            future: getAllPosts(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                
                return ListView.builder(
                  itemBuilder:(context,position){
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(),
                        title: Text(snapshot.data[position].name),
                        subtitle: Text(snapshot.data[position].description),
                        trailing: Icon(Icons.favorite,color: Colors.red,),
                      ),
                    );
                } ,itemCount: snapshot.data.length,);
                
                
              }else{
                
                return Center(
                  child: CircularProgressIndicator(),
                );
                
              }
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
            
          },child: Icon(Icons.add),),
        );
    }

  Future<List<PostData>> getAllPosts() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userId = preferences.getString("user");
      var response= await http.get('https://flutter.smarttersstudio.com/test/getAllPosts.php?id=$userId');
      List<PostData> data = postDataFromJson(response.body);
      return data;
  }
}
