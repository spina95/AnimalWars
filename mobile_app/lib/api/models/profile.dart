import '../../export.dart';

class Profile {
  int id;
  String first_name;
  String last_name;
  String email;
  String image_url;

  Profile({this.first_name, this.last_name, this.email,});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    if(json['profilepicture'] != null)
      image_url = json['profilepicture'];
    else
      image_url = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['email'] = this.email;
    return data;
  }
}

Profile currenUser;