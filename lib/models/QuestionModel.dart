// To parse this JSON data, do
//
//     final question = questionFromMap(jsonString);

import 'dart:convert';

Question questionFromMap(String str) => Question.fromMap(json.decode(str));

String questionToMap(Question data) => json.encode(data.toMap());

class Question {
    Question({
        this.id,
        this.title,
        this.createdAt,
        this.v,
    });
String ?id;
    String? title;
    DateTime? createdAt;
    int? v;

    factory Question.fromMap(Map<String, dynamic> json) => Question(
        id: json["_id"],
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "createdAt": createdAt!.toIso8601String(),
        "__v": v,
    };
}
