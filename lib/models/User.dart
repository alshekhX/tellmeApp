// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

import 'RecordModel.dart';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
    User({
        this.email,
        this.country,
        this.id,
        this.username,
        this.role,
        this.createdAt,
        this.v,
        this.records,
        this.userId,
    });

    String? email;
    String? country;
    String  ?id;
    String? username;
    String ?role;
    DateTime? createdAt;
    int? v;
    List<Record>? records;
    String ?userId;

    factory User.fromMap(Map<String, dynamic> json) => User(
        email: json["email"] == null ? null : json["email"],
        country: json["country"] == null ? null : json["country"],
        id: json["_id"] == null ? null : json["_id"],
        username: json["username"] == null ? null : json["username"],
        role: json["role"] == null ? null : json["role"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        v: json["__v"] == null ? null : json["__v"],
        records: json["records"] == null ? null : List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        userId: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toMap() => {
        "email": email == null ? null : email,
        "country": country == null ? null : country,
        "_id": id == null ? null : id,
        "username": username == null ? null : username,
        "role": role == null ? null : role,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "__v": v == null ? null : v,
        "records": records == null ? null : List<dynamic>.from(records!.map((x) => x.toMap())),
        "id": userId == null ? null : userId,
    };
}
