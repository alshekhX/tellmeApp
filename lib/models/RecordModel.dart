// To parse this JSON data, do
//
//     final record = recordFromMap(jsonString);

import 'dart:convert';

Record recordFromMap(String str) => Record.fromMap(json.decode(str));

String recordToMap(Record data) => json.encode(data.toMap());

class Record {
    Record({
        this.id,
        this.title,
                this.likes,

        this.record,
        this.question,
        this.createdAt,
        this.user,
        this.v,
    });

    String? id;
    String? title;
        int? likes;

    String? record;
        String? user;

    String? question;
    DateTime? createdAt;
    int? v;

    factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["_id"],
        title: json["title"],
        record: json["record"],
                likes: json["likes"] == null ? null : json["likes"],

                user: json["user"],

        question: json["question"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "record": record,
        "question": question,
        "createdAt": createdAt!.toIso8601String(),
        "__v": v,
    };
}
