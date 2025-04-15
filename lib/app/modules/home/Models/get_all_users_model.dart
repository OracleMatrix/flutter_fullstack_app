// To parse this JSON data, do
//
//     final getAllUsersModel = getAllUsersModelFromJson(jsonString);

import 'dart:convert';

List<GetAllUsersModel> getAllUsersModelFromJson(String str) =>
    List<GetAllUsersModel>.from(
      json.decode(str).map((x) => GetAllUsersModel.fromJson(x)),
    );

String getAllUsersModelToJson(List<GetAllUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllUsersModel {
  int? id;
  String? name;
  String? email;

  GetAllUsersModel({this.id, this.name, this.email});

  factory GetAllUsersModel.fromJson(Map<String, dynamic> json) =>
      GetAllUsersModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}
