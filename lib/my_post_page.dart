import 'package:blogapp/PostData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class MyPostPage extends StatefulWidget {
  @override
  _MyPostPageState createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
      ),
      body: FutureBuilder< List<PostData> >(
        future: getMyPosts(),
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
    );
  }
  
  Future<List<PostData>> getMyPosts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString("user");
    var response= await http.get('https://flutter.smarttersstudio.com/test/getMyPosts.php?id=$userId');
    List<PostData> data = postDataFromJson(response.body);
    return data;
  }
}
