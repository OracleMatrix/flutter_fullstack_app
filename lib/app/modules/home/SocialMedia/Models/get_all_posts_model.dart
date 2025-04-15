import 'dart:convert';

List<GetAllPostsModel> getAllPostsModelFromJson(String str) =>
    List<GetAllPostsModel>.from(
      json.decode(str).map((x) => GetAllPostsModel.fromJson(x)),
    );

String getAllPostsModelToJson(List<GetAllPostsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllPostsModel {
  int? id;
  int? userId;
  String? title;
  String? content;
  DateTime? createdAt;
  String? email;
  String? name;

  GetAllPostsModel({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.createdAt,
    this.email,
    this.name,
  });

  factory GetAllPostsModel.fromJson(Map<String, dynamic> json) =>
      GetAllPostsModel(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        content: json["content"],
        createdAt:
            json["created_at"] == null
                ? null
                : DateTime.parse(json["created_at"]),
        email: json["email"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "content": content,
    "created_at": createdAt?.toIso8601String(),
    "email": email,
    "name": name,
  };
}
