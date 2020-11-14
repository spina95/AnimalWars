import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../export.dart';

class Api {
  Dio dio;
  final storage = FlutterSecureStorage();
  String SERVER_IP = "http://192.168.1.5:8000";

  Api(){
    BaseOptions options = new BaseOptions(
        baseUrl: SERVER_IP,
        connectTimeout: 5000,
        receiveTimeout: 3000,
    );
    dio = new Dio(options);
  }

  /// Return token or empty String
  Future<String> jwtOrEmpty() async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  Future removeToken() async {
    api.storage.delete(key: "jwt");
    api.dio.options.headers["Authorization"] = null;
  }

  /// Login with email and password
  Future login(String email, String password) async {
    try {
      Response response = await dio.post("/users/rest-auth/login/",
      data: {
        'email': email,
        'password': password,
      });
      if(response.statusCode == 200){
        storage.write(key: "jwt", value: response.data['key']);
        dio.options.headers["Authorization"] = "token " + response.data['key'];
      } 
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Logout user
  Future logout() async {
    try {
      Response response = await dio.post("/users/rest-auth/logout/");
      if(response.statusCode == 200){
        storage.delete(key: "jwt");
        dio.options.headers["Authorization"] = null;
      } else {
        throw "error 1";
      }
      
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Get current user data
  Future<Profile> getCurrentUser() async {
    try {
      var jwt = await storage.read(key: "jwt");
      Response response = await dio.get("/users/rest-auth/user/");
      currenUser = Profile.fromJson(response.data);
      return currenUser;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Register a new user
  Future registerUser(String name, String surname, String email, String password1, String password2, File image) async {
    try {
      String fileName;
      if(image != null)
        fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profilepicture": image != null ? await MultipartFile.fromFile(image.path, filename:fileName) : null,
        'first_name': name,
        'last_name': surname,
        'email': email,
        'password1': password1,
        'password2': password2,
      });
      Response response = await dio.post("/users/rest-auth/registration/",
      data: formData);
      storage.write(key: "jwt", value: response.data['key']);
      dio.options.headers["Authorization"] = "token " + response.data['key'];
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Retrieve two random images
  Future<List<ImagePost>> randomImages() async {
    try {
      Response response = await dio.get("/images/randomImages");
      List<ImagePost> data = response.data.map<ImagePost>((m) => new ImagePost.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Retrieve images of a profile
  Future<List<ImagePost>> imagesProfile(int profile_id) async {
    try {
      Response response = await dio.get("/images/profileimages", queryParameters: {'profile_id': profile_id});
      List<ImagePost> data = response.data.map<ImagePost>((m) => new ImagePost.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Post an image
  Future<ImagePost> saveImage(File file, String name, int user_id, List<String> tags) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename:fileName),
        "name": name,
        "user": user_id
      });
      Response response = await dio.post("/images/images", data: formData);
      ImagePost image = ImagePost.fromJson(response.data);
      if(tags.length != 0){
        List<Future> requests = List<Future>();
        tags.forEach((el) => requests.add(dio.post("/images/tags", data: {
          "name": el,
          "image": image.id
        })));
        await Future.wait(requests);
        return image;
      }
      return image;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Remove an image
  Future removeImage(int id) async {
    try {
      Response response = await dio.delete("/images/images/" + id.toString());
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Retrieve data of a profile
  Future<Profile> imageUser(int id) async {
    try {
      Response response = await dio.get("/users/" + id.toString(), );
      Profile data = new Profile.fromJson(response.data);
      return data;
    } on DioError catch(e) {  
      throw(e);
    }
  }

  /// Retrieve newest images
  Future<List<ImagePost>> newestImages() async {
    try {
      Response response = await dio.get("/images/newestImages");
      List<ImagePost> data = response.data.map<ImagePost>((m) => new ImagePost.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Retrieve images with order descending
  Future<List<ImagePost>> higherScore() async {
    try {
      Response response = await dio.get("/images/higherscore");
      List<ImagePost> data = response.data.map<ImagePost>((m) => new ImagePost.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Retrieve images with order ascending
  Future<List<ImagePost>> lowerScore() async {
    try {
      Response response = await dio.get("/images/lowerscore");
      List<ImagePost> data = response.data.map<ImagePost>((m) => new ImagePost.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Vote between two images
  Future voteWinnerLoser(int winner_id, int loser_id) async {
    try {
      Response response = await dio.post("/images/vote", queryParameters: {
        'winner_id': winner_id,
        'loser_id': loser_id
      });
      return;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Retrieve tags of an image
  Future<List<Tag>> imageTags(int image_id) async {
    try {
      Response response = await dio.get("/images/imageTags", queryParameters: {'image_id': image_id});
      List<Tag> data = response.data.map<Tag>((m) => new Tag.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      throw e;
    }
  }

  /// Search images with tags
  Future<List<ImagePost>> imagesTags(String search, int searchMode) async {
    try {
      List<String> list = search.split(' ');
      list.remove(""); 
      var uri = Uri(
        path: '/images/searchTag',
        queryParameters: {
          "order": searchMode == 0 ? "descending" : searchMode == 1 ? "ascending" : "newest",
          "tag": list
        },
      );
      Response response = await dio.getUri(uri);
      List<ImagePost> data = response.data.map<ImagePost>((m) => new ImagePost.fromJson(m)).toList();
      return data;
    } on DioError catch(e) {  
      throw e;
    }
  }
}