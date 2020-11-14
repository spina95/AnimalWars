import 'dart:io';
import 'package:flutter/material.dart';
import '../../export.dart';

class PostImage extends StatefulWidget {
  File image;
  PostImage({Key key, this.image}) : super(key: key);

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  List<String> tags = List<String>();

  addTag(){
    var tag = tagController.text;
    if(tag != ""){
      tagController.text = "";
      setState(() {
        tags.add(tag);
      });
    }
  }

  removeTag(int index){
    setState(() {
      tags.removeAt(index);
    });
  }

  save() async{
    if(nameController.text != ""){
      var response = await api.saveImage(widget.image, nameController.text, currenUser.id, tags);
      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => UserPage(id: currenUser.id, back: false,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           backgroundColor: Colors.white,
           centerTitle: true,
           iconTheme: IconThemeData(color: Colors.black54),
           title: Text("Post image", style: TextStyle(color: Colors.black),),
           actions: <Widget>[
             FlatButton(
               onPressed: () => save(),
               child: Text("Save", style: TextStyle(fontSize: 18, color: ColorsApp.PRIMARY_COLOR),),
             )
           ],
         ),
       body: Column(
         children: <Widget>[
           Image.file(widget.image),
           Expanded(
             child: Padding(
              padding: EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: tags.length + 2,
                separatorBuilder: (context, index) => SizedBox(height: 16,),
                itemBuilder: (BuildContext context, int index){
                  if(index == 0){
                    return TextField(
                     controller: nameController,
                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                     decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 18),
                    ),
                   );
                  }
                  if(index == 1){
                    return Row(
                      children: <Widget>[
                        Flexible( child: TextField(
                          controller: tagController,
                          decoration: InputDecoration(
                            hintText: "Insert a tag"
                          ),
                        )),
                        SizedBox(width: 20,),
                        Container(
                          width: 40,
                          height: 40,
                          child: RaisedButton(
                            onPressed: () => addTag(),
                            child: Text("+", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24),),
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          )
                        )
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(tags[index - 2], style: TextStyle(fontSize: 18),),
                      Container(
                          width: 40,
                          height: 40,
                          child: RaisedButton(
                            onPressed: () => removeTag(index - 2),
                            child: Text("-", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24),),
                            color: ColorsApp.PRIMARY_COLOR,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          )
                        )
                    ],
                  );
                },
               ),
             ),
           )
         ],
       ),
       ),
    );
  }
}