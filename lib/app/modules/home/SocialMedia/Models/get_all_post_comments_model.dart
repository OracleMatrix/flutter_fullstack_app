import 'dart:convert';

List<GetAllPostCommentsModel> getAllPostCommentsModelFromJson(String str) =>
    List<GetAllPostCommentsModel>.from(
      json.decode(str).map((x) => GetAllPostCommentsModel.fromJson(x)),
    );

String getAllPostCommentsModelToJson(List<GetAllPostCommentsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllPostCommentsModel {
  int? id;
  int? postId;
  int? userId;
  String? content;
  DateTime? createdAt;
  String? name;
  String? email;

  GetAllPostCommentsModel({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.createdAt,
    this.name,
    this.email,
  });

  factory GetAllPostCommentsModel.fromJson(Map<String, dynamic> json) =>
      GetAllPostCommentsModel(
        id: json["id"],
        postId: json["post_id"],
        userId: json["user_id"],
        content: json["content"],
        createdAt:
            json["created_at"] == null
                ? null
                : DateTime.parse(json["created_at"]),
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_id": postId,
    "user_id": userId,
    "content": content,
    "created_at": createdAt?.toIso8601String(),
    "name": name,
    "email": email,
  };
}
