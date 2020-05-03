import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddPostPage extends StatefulWidget {
    
    @override
    _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
    String _titleError,_bodyError;
    TextEditingController _titleController , _bodyController ;
    bool _isLoading = false ;
    
    @override
  void initState() {
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    super.initState();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Your Post')
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    errorText: _titleError,
                    border: OutlineInputBorder(),
                    hintText: 'Hiiii',
                    labelText: 'Title',
                  ),
                ),
                SizedBox(
                  height:30
                ),
                TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    errorText: _bodyError,
                    border: OutlineInputBorder(),
                    hintText: 'Hello Body',
                    labelText: 'Body',
                  ),
                ),
                SizedBox(
                  height:30
                ),
                _isLoading?CupertinoActivityIndicator():RaisedButton(
                  onPressed: () async {
                  
                  setState(() {
                    _titleError = null ;
                    _bodyError = null ;
                  });
                  
                  String title = _titleController.text ;
                  String body = _bodyController.text ;
                  
                  if(title.isEmpty){
                    setState(() {
                      _titleError = "Title is Empty";
                    });
                  }else if(body.isEmpty){
                    setState(() {
                      _bodyError = "Body is Empty";
                    });
                  }else{
                    setState(() {
                      _isLoading = true;
                    });
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    String id = preferences.getString("user");
                    http.get('https://flutter.smarttersstudio.com/test/addPost.php?id=$id&title=$title&body=$body')
                    .then((response){
                      Navigator.pop(context);
                    });
                  
                  }
                },child:Text('Add Post'))
              ],
            ),
          ),
        );
    }
}
