import 'package:flutter/material.dart';
import '../../export.dart';

class ImageViewPage extends StatefulWidget {

  ImagePost image;
  ImageViewPage({Key key, this.image}) : super(key: key,);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {

  @override
  void initState() { 
    super.initState();
  }

  Future _fetchData() async {
    return Future.wait([
      api.imageTags(widget.image.id),
      api.imageUser(widget.image.user)
    ]);
  }

  tagsList(List<Tag> tags){
    if(tags != null){
      return Container(
        height: 30,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(32, 0, 16, 0),
          itemCount: tags.length,
          separatorBuilder: (context, index) => SizedBox(width: 16,),
          itemBuilder: (context, index){
            return Container(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),   
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(16)
              ),
              child: Text(tags[index].name, style: TextStyle(color: Colors.white, fontSize: 15),),
            );
          },
        )
      );
    } else {
      return SizedBox();
    }
  }

  Widget deleteButton(Profile user){
    if(user.id == currenUser.id){
      return IconButton(icon: Icon(Icons.delete), onPressed: (){
        api.removeImage(widget.image.id).then((val){
          Navigator.of(context).pop();
        });
      },);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<Tag> tags = snapshot.data[0];
            Profile user = snapshot.data[1];
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Column(
                  children: [
                    Text(widget.image.name, style: TextStyle(color: Colors.white),),
                    Text(user.first_name + " " + user.last_name, style: TextStyle(fontSize: 14),)
                  ]
                ),
                actions: <Widget>[
                  deleteButton(user)
                ],
                centerTitle: true,
                elevation: 0,
              ),
              body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tagsList(tags),
                SizedBox(height: 16,),
                Expanded(
                  child: Container(
                    child: Center(child: Image.network(widget.image.image_url, width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth,),
                  ))
                ),
              ]
            ));
          }
          if(snapshot.hasError){
            return Text("error");
          }
          return CustomProgressIndicator();
        }
    );
  }
}