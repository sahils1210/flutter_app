/*
* We use a model class to define a user. Also note, how we use a constructor to create a new User object out of a dynamic map object.
* */

import 'dart:convert';

class User {
  final int id;
  final int branch_master_id;
  final String username;
  final String email;
  final String password;
  final String city_code;
  final String user_type;
  final String medium;
  final String default_search_city_code;
  final String gender;
  final String status;
  final int is_sync;
  final String vendor_user_contact;
  final String vendor_user_profile_image;
  final String created_at;
  final String updated_at;

  User(
      {this.id,
      this.branch_master_id,
      this.username,
      this.email,
      this.password,
      this.city_code,
      this.user_type,
      this.medium,
      this.default_search_city_code,
      this.gender,
      this.status,
      this.is_sync,
      this.vendor_user_contact,
      this.vendor_user_profile_image,
      this.created_at,
      this.updated_at});

  /*User.map(dynamic obj) {
    this.username = obj["username"];
    this.password = obj["password"];
  }

  String get username => username;
  String get password => password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;

    return map;
  }*/

  factory User.fromJson(Map<String, dynamic> json) {
    print('Entered User.fromJson: ' + json.toString());

    return User(
      id: json['id'] as int,
      branch_master_id: json['vendor_branch_master_id'] as int,
      username: json['vendor_user_name'] as String,
      email: json['vendor_user_email'] as String,
      password: json['vendor_user_password'] as String,
      city_code: json['city_code'] as String,
      user_type: json['user_type'] as String,
      medium: json['medium'] as String,
      default_search_city_code: json['default_search_city_code'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String,
      is_sync: json['is_sync'] as int,
      vendor_user_contact: json['vendor_user_contact'] as String,
      vendor_user_profile_image: json['vendor_user_profile_image'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );
  }

  static List<User> allFromResponse(String response) {
    print('Entered allFromResponse: ' + response);
    print('Entered allFromResponse decode: ' + json.decode(response));
    var decodedJson = json.decode(response).cast<String, dynamic>();
    print('allFromResponse: ' + decodedJson);

    return decodedJson['status']
        .cast<Map<String, dynamic>>()
        .map((obj) => User.fromMap(obj))
        .toList()
        .cast<User>();
  }

  static User fromMap(Map map) {
    var name = map['name'];

    return new User(
        id: map['id'],
        branch_master_id: map['vendor_branch_master_id'],
        username: map['vendor_user_name'],
        email: map['vendor_user_email'],
        password: map['vendor_user_password'],
        city_code: map['city_code'],
        user_type: map['user_type'],
        medium: map['medium'],
        default_search_city_code: map['default_search_city_code'],
        gender: map['gender'],
        status: map['status'],
        is_sync: map['is_sync'],
        vendor_user_contact: map['vendor_user_contact'],
        created_at: map['created_at'],
        vendor_user_profile_image: map['vendor_user_profile_image'],
        updated_at: map['updated_at']);
  }

  /*Future<User> getUserDetails() async{
    if(User)
    return ;
  }*/

}
