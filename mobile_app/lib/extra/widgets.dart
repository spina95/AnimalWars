import 'package:flutter/material.dart';
import '../export.dart';

Widget CustomProgressIndicator(){
  return Container(
    height: 80,
    width: 80,
    decoration: BoxDecoration(
      color: Colors.black26,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(ColorsApp.PRIMARY_COLOR),
      ),
    ),
  );
}