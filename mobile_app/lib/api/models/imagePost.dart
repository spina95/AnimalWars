import '../../export.dart';
import 'package:intl/intl.dart';

class ImagePost {

  int id;
  int user;
  String name;
  String image_url;
  double score;
  int wins;
  int lost;
  DateTime uploaded_at;

  ImagePost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    name = json['name'];
    image_url = json['image'];
    score = json['score'];
    wins = json['wins'];
    lost = json['lost'];
    uploaded_at = DateTime.parse(json['uploaded_at'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['image_url'] = this.image_url;
    data['score'] = this.score;
    data['wins'] = this.wins;
    data['loses'] = this.lost;
    return data;
  }
}