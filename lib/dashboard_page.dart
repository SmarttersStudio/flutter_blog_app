import 'package:blogapp/PostData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
              
              }),
              IconButton(icon: Icon(Icons.power_settings_new), onPressed: (){
    
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
      var response= await http.get('https://flutter.smarttersstudio.com/test/getAllPosts.php?id=116');
      List<PostData> data = postDataFromJson(response.body);
      return data;
  }
}
