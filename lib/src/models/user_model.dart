// To parse this JSON data, do
//
//     final admin = adminFromJson(jsonString);

import 'dart:convert';

User adminFromJson(String str) => User.fromJson(json.decode(str));

String adminToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id = '',
    this.name = '',
    this.lastname = '',
    this.imageUrl = '',
    this.available = true,
    this.phone = '',
    this.email = '',
    this.password = '',
    this.token = '',
    this.nameDatabase = '',
  });

  String id;
  String name;
  String lastname;
  String imageUrl;
  bool available;
  String phone;
  String email;
  String password;
  String token;
  String nameDatabase;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        imageUrl: json["imageUrl"],
        available: json["available"],
        phone: json["phone"],
        email: json["email"],
        token: json["token"],
        nameDatabase: json["name_database"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "imageUrl": imageUrl,
        "available": available,
        "phone": phone,
        "email": email,
        "token": token,
        "name_database": nameDatabase,
      };
}
