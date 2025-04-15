import 'dart:convert';

UserGetDataModel userGetDataModelFromJson(String str) =>
    UserGetDataModel.fromJson(json.decode(str));

String userGetDataModelToJson(UserGetDataModel data) =>
    json.encode(data.toJson());

class UserGetDataModel {
  int? id;
  String? name;
  String? email;

  UserGetDataModel({this.id, this.name, this.email});

  factory UserGetDataModel.fromJson(Map<String, dynamic> json) =>
      UserGetDataModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}
