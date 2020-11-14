import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;
import '../../export.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    SearchPage(),
    DiscoverPage(),
    UserPage(id: currenUser.id, back: false,)
  ];

  @override
  void initState() {
    super.initState();
    
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: _children[_currentIndex], // new
     bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped, // new
       currentIndex: _currentIndex, 
       selectedIconTheme: IconThemeData(color: ColorsApp.PRIMARY_COLOR),
       selectedLabelStyle: TextStyle(color: ColorsApp.PRIMARY_COLOR),
       selectedItemColor: ColorsApp.PRIMARY_COLOR,
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.search),
           title: Text('Search'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.image),
           title: Text('Vote'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.person),
           title: Text('Profile')
         )
       ],
     )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
