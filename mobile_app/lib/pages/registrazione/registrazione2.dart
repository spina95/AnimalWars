import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../export.dart';

class Registrazione2Page extends StatefulWidget {  

  File image;
  String firstname;
  String lastname;

  Registrazione2Page({Key key, this.firstname, this.lastname, this.image}) : super(key: key);

  @override
  _Registrazione2PageState createState() => _Registrazione2PageState();
}

class _Registrazione2PageState extends State<Registrazione2Page> {

  String errorMessage = "";

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _password1Controller = TextEditingController();

  final TextEditingController _password2Controller = TextEditingController();

  void confirm() async{
    bool check = false;
    if(_emailController.text == ""){
      check = true;
      setState(() {
        errorMessage = "Insert a valid email";
      });
    }
    else if(_password1Controller.text == ""){
      check = true;
      setState(() {
        errorMessage = "Insert a valid password";
      });
    }  
    else if(_password2Controller.text == ""){
      check = true;
      setState(() {
        errorMessage = "Confirm your password";
      });
    }  
    else if(_password1Controller.text != _password2Controller.text){
      check = true;
      setState(() {
        errorMessage = "Check the passwords are equal";
      });
    }  
    if(check == false){
      setState(() {
        errorMessage = "";
      });
      api.registerUser(widget.firstname, widget.lastname, _emailController.text, _password1Controller.text, _password2Controller.text, widget.image).then((value){
        api.getCurrentUser().then((value){
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage()
        )
      );
      });
      }).catchError((error){
        setState(() {
          errorMessage = "Check all the fields are correct";
        });
      });
    }
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
            customTextfield("Email", _emailController, false),
            SizedBox(height: 20,),
            customTextfield("Password", _password1Controller, true),
            SizedBox(height: 20,),
            customTextfield("Confirm password", _password2Controller, true),
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