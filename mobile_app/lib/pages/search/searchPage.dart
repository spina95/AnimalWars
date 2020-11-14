import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../export.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();
  String searchText = "";
  int searchMode = 0;

  @override
  void initState() { 
    super.initState();
  }

  Future searchMovies(String text) async {
    List<ImagePost> images;
    if(searchText == "") {
      if(searchMode == 0)
        images = await api.higherScore();
      if(searchMode == 1)
        images = await api.lowerScore();
      if(searchMode == 2)
        images = await api.newestImages();
    } else {
      var occurence = searchText.length - searchText.replaceAll(" ", "").length;
      var lenght = searchText.split(" ").length - 1;
      if(searchText.contains(" ") && occurence == lenght)
        images = await api.imagesTags(searchText, searchMode);
      else
        return null;
    }
    List<Future<Profile>> requests = List<Future<Profile>>();
    List<Future<List<Tag>>> tags = List<Future<List<Tag>>>();
    images.forEach((el) => requests.add(api.imageUser(el.user)));
    images.forEach((el) => tags.add(api.imageTags(el.id)));
    var responses = await Future.wait(requests);
    var tagResponse = await Future.wait(tags);
    return [images, responses, tagResponse];
  }

  @override
  Widget build(BuildContext context) {

    tagsList(List<Tag> tags){
      if(tags.length != 0){
        return Container(
          height: 40,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            itemCount: tags.length,
            separatorBuilder: (context, index) => SizedBox(width: 16,),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),   
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Center(child: Text(tags[index].name, style: TextStyle(color: Colors.black, fontSize: 15),)),
              );
            },
          )
        );
      } else {
        return SizedBox(height: 0,);
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow()]
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          searchText = value;
                        });
                      },
                      controller: searchController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Search', 
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white
                          ),
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        filled: true,
                        hintStyle: new TextStyle(color: Colors.grey[600], fontSize: 18, ),
                        fillColor: Colors.grey[100]
                      ),
                    )  
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Higher score", style: TextStyle(
                          color: searchMode == 0 ? ColorsApp.PRIMARY_COLOR : Colors.black,
                          fontWeight: searchMode == 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16
                        ),),
                        onPressed: (){
                          this.setState((){searchMode = 0;});
                        },
                      ),
                      FlatButton(
                        child: Text("Lower score", style: TextStyle(
                          color: searchMode == 1 ? ColorsApp.PRIMARY_COLOR : Colors.black,
                          fontWeight: searchMode == 1 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16
                        )),
                        onPressed: (){
                          this.setState((){searchMode = 1;});
                        },
                      ),
                      FlatButton(
                        child: Text("Newest", style: TextStyle(
                          color: searchMode == 2 ? ColorsApp.PRIMARY_COLOR : Colors.black,
                          fontWeight: searchMode == 2 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16
                        )),
                        onPressed: (){
                          this.setState((){searchMode = 2;});
                        },
                      )
                    ],
                  )
                ]
              )
            ),
          Expanded(
            child: FutureBuilder(
              future: searchMovies(searchText),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<ImagePost> images = snapshot.data[0];
                  List<Profile> users = snapshot.data[1];
                  List<List<Tag>> tags = snapshot.data[2];
                  return ListView.separated(
                    itemCount: images.length,
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    separatorBuilder: (context,index) => SizedBox(height: 36,),
                    itemBuilder: (context, index) {
                      return Container (
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 12, 8, 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => UserPage(id: users[index].id, back: true,)),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(users[index].image_url,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  ),
                                  SizedBox(width: 8,),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(text: images[index].name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        TextSpan(text: '  |  ', style: TextStyle(fontSize: 16)),
                                        TextSpan(text: users[index].first_name + " " + users[index].last_name, style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: <Widget>[
                                      Text(images[index].score.toStringAsFixed(3), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                      Text("score", style: TextStyle(fontSize: 14),),
                                    ],
                                  )
                                ],
                              )
                            ),
                            tagsList(tags[index]),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ImageViewPage(image: images[index],)),
                                );
                              },
                              child: Image.network(
                                images[index].image_url,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                            )
                          ]
                        )
                      );
                    },
                  );
                }
                if(snapshot.hasError)
                  return Center(child: Text("An error has occured"),);
                if(snapshot.data == null)
                    return Container();
                return Center(child: CustomProgressIndicator(),);
              }
            ),
          )
        ]
      )
    );
  }
}