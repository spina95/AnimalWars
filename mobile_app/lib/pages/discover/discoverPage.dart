import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../export.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

Widget title(String text){
  return Container(
    height: 38,
    width: double.infinity,
    margin: EdgeInsets.only(left: 12),
    child: Text(text, style: TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w900),),
  );
}

class _DiscoverPageState extends State<DiscoverPage> {

  int indexImage = 0;
  List<ImagePost> images;
  List<ImagePost> prevImages;
  Profile user1, user2;
  bool reload = true;
  bool isLoading = false;

  @override
  void initState() { 
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  _fetchData() async {
    try {
      if(reload == true){
        List<ImagePost> images = await api.randomImages();
        Profile user1 = await api.imageUser(images[0].user);
        Profile user2 = await api.imageUser(images[1].user);
        reload = false;
        return [images, user1, user2];
      } else {
        return [images, user1, user2];
      }
    } catch(e){
      return Future.error(e);
    }
  }

  vote(int index, List<ImagePost> images) {
    int winner_id = 0;
    int loser_id = 0;
    if(index == 0){
      winner_id = images[0].id;
      loser_id = images[1].id;
    } else {
      winner_id = images[1].id;
      loser_id = images[0].id;
    }
    this.setState((){
      isLoading = true;
    });
    api.voteWinnerLoser(winner_id, loser_id).then((response){
      prevImages = images;
      if(index == 0){
        prevImages[0].wins += 1;
        prevImages[1].lost += 1;
      } else {
        prevImages[0].lost += 1;
        prevImages[1].wins += 1;
      }
      this.setState((){
        reload = true;
        isLoading = false;
        indexImage = 0;
      });

    });
  }

  image(ImagePost image){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 80,
          width: 130,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey,
            boxShadow: [BoxShadow(blurRadius: 5, offset: Offset(0, 5), color: Colors.black45)],
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(image.image_url),
              fit: BoxFit.fill
            )
          ),
        ),
        Text(image.wins.toString() + "/" + image.lost.toString(), style: TextStyle(fontSize: 20),),
        Text("win/lost", style: TextStyle(fontSize: 16))
      ],
    );
  }

  showPrevImages(){
    if(prevImages != null){
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image(prevImages[0]),
            image(prevImages[1])
          ],
        ),
      );
    } 
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text("Vote", style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if(this.isLoading == true){
            return Center(child: CustomProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(
              child: Text("An error has occured"),
            );
          } 
          if(snapshot.hasData){
            images = snapshot.data[0];
            user1 = snapshot.data[1];
            user2 = snapshot.data[2];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showPrevImages(),
                SizedBox(height: 50,),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: images[0].name, style: TextStyle(fontSize: 24, fontWeight: indexImage == 0 ? FontWeight.bold : FontWeight.normal)),
                        TextSpan(text: '  VS  '),
                        TextSpan(text: images[1].name, style: TextStyle(fontSize: 24, fontWeight: indexImage == 1 ? FontWeight.bold : FontWeight.normal)),
                      ],
                    ),
                  )
                )),
                CarouselSlider.builder(
                  itemCount: 2,
                  enlargeCenterPage: true,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index) => {
                    this.setState((){
                      indexImage = index;
                    })
                  },
                  itemBuilder: (BuildContext context, int itemIndex) => 
                    Container(
                      child: GestureDetector(
                        onTap: () => vote(itemIndex, images),
                        child: Container(
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            boxShadow: [BoxShadow(blurRadius: 7, offset: Offset(0, 5), color: Colors.black87)],
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(images[itemIndex].image_url),
                              fit: BoxFit.fill
                            )
                          ),
                        ),
                      )
                    )
                  ),
              ],
            );
          }
          return Center(child: CustomProgressIndicator());
        },
      )
    );
  }
}