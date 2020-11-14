import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../export.dart';

class Registrazione1Page extends StatefulWidget {  

  DateTime birthdate;
  String name;
  String surname;

  Registrazione1Page({Key key, this.birthdate, this.name, this.surname}) : super(key: key);

  @override
  _Registrazione1PageState createState() => _Registrazione1PageState();
}

class _Registrazione1PageState extends State<Registrazione1Page> {

  String errorMessage = "";
  File image;

  final TextEditingController _firstnameController = TextEditingController();

  final TextEditingController _lastnameController = TextEditingController();


  void confirm() async{
    bool check = false;
    if(_firstnameController.text == ""){
      check = true;
      setState(() {
        errorMessage = "Insert a valid name";
      });
    }
    else if(_lastnameController.text == ""){
      check = true;
      setState(() {
        errorMessage = "Insert a valid surname";
      });
    }  
    if(check == false){
      setState(() {
        errorMessage = "";
      });
      
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Registrazione2Page(
          firstname: _firstnameController.text, 
          lastname: _lastnameController.text,
          image: this.image,
        )
      ));
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
    });
  }

  Widget profileImage(){
    if(this.image != null){
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.file(this.image, width: 100, height: 100, fit: BoxFit.fitHeight,),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
        width: 100, height: 100,),
    );
  }

  Widget customTextfield(String text, TextEditingController controller, bool secret) => Container(
    height: 50,
    child: TextField(
      controller: controller,
      textAlign: TextAlign.center,
      obscureText: secret,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(25.0),
          ),
        ),
        contentPadding: EdgeInsets.all(10),
        filled: true,
        hintStyle: new TextStyle(color: Colors.grey[600], fontSize: 18, ),
        hintText: text,
        fillColor: Colors.white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          colors: <Color>[
            Color.fromRGBO(170, 60, 54, 1), 
            Color.fromRGBO(255, 105, 97, 1)],
          ), 
        ),
        child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 100,),
            Text("Registration",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            SizedBox(height: 30),
            customTextfield("First name", _firstnameController, false),
            SizedBox(height: 20,),
            customTextfield("Last name", _lastnameController, false),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                profileImage(),
                SizedBox(width: 8,),
                FlatButton(
                  child: Text("Select image", style: TextStyle(color: Colors.white, fontSize: 18),),
                  onPressed: () => getImage(),
                )
              ],
            ),
            SizedBox(height: 20,),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: Colors.transparent),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromRGBO(14, 31, 252, 1), 
                    Color.fromRGBO(80, 126, 255, 1)],
                ), 
                boxShadow: [
              ]),
              child: FlatButton(
                onPressed: confirm,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.transparent)),
                textColor: Colors.white,
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(errorMessage,
                style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    ));
  }
}