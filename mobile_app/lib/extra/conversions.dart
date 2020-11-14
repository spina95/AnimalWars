import 'package:intl/intl.dart';

class Conversions {

  String dateToStringJson(DateTime date){
    String out = DateFormat('yyyy-MM-dd').format(date);
    return out;
  }

  DateTime stringJsonToDate(String date){
    DateTime out = DateFormat('yyyy-MM-dd').parse(date);
    return out;
  }

  DateTime stringJsonToTime(String time){
    DateTime out = DateFormat('HH:mm:ss').parse(time);
    return out;
  }

}


final Conversions conversions = Conversions();