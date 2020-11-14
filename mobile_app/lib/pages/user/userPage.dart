import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../export.dart';

class UserPage extends StatefulWidget {
  int id;
  bool back;

  UserPage({Key key, this.id, this.back}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  String profileUrl = "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
  List<ImagePost> images;
  Profile user;
  bool logout = false;

  Future _fetchData() async {
    if(logout == false){
      return Future.wait([
        api.imageUser(widget.id),
        api.imagesProfile(widget.id)
      ]).catchError((e){
         return Future.error(e);
      });
    }
  }

  postImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostImage(image: image,)),
    );
  }


  Widget columnText(String title, String value){
    return Column(
      children: <Widget>[
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
        Text(title, style: TextStyle(fontSize: 14,),)
      ],
    );
  }

  Widget profile(){
    return Container(
      height: 220,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black87)]
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container( 
              height: 100,
              width: 100,
              child: Image.network(user.image_url != null ? user.image_url : profileUrl, 
                fit: BoxFit.fitHeight,),
            )
          ),
          SizedBox(height: 16,),
          Text(user.first_name + " " + user.last_name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              columnText("POSTED", images.length.toString()),
              columnText("AVERAGE SCORE", images.length == 0 ? "0" : ((images.map((item) => item.score).reduce((a, b) => a + b))/images.length).toStringAsFixed(3)),
              columnText("WIN/LOST", images.length == 0 ? "0/0" : (images.map((item) => item.wins).reduce((a, b) => a + b)).toString() + "/" + ((images.map((item) => item.lost)).reduce((a, b) => a + b)).toString())
            ],
          )
        ],
      )
      
    );
  }

  imagesGrid(List<ImagePost> images) {
    if(images != null){   
      return Expanded(
        child: Container(
        child: GridView.count(
          crossAxisCount: 3,
          children: new List<Widget>.generate(images.length, (index) {
            return new GridTile(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageViewPage(image: images[index],)),
                  );
                },
                child: Image.network(
                  images[index].image_url,
                  fit: BoxFit.fitHeight,
                )
              )
            );
          })
        )
      ));
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            user = snapshot.data[0];
            images = snapshot.data[1];
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black54),
                leading: widget.back == false ? IconButton(icon: Icon(Icons.camera_alt, size: 30,), onPressed: () => postImage())
                  : IconButton(icon: Icon(Icons.arrow_back, size: 30,), onPressed: (){Navigator.pop(context);},),
                actions: <Widget>[
                  user.id != currenUser.id ? Container() :
                  FlatButton(
                    child: Text("Logout"),
                    onPressed: () => {
                      api.logout().then((value){
                        logout = true;
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          LoginPage()), (Route<dynamic> route) => false);
                      })
                    },
                  )
                ],
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body:  Column(
                children: [
                  profile(),
                  imagesGrid(images)
                ]
              )
            );
          }
          if(snapshot.hasError){
            return Center(child: Text("An error has occured"),);
          } else {
            return Center(child: CustomProgressIndicator(),
            );
          }
        },
      );
  }
}