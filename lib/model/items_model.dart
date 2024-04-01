import 'dart:convert';

List<ItemsModel> itemsModelFromJson(String str) =>
    List<ItemsModel>.from(json.decode(str).map((x) => ItemsModel.fromJson(x)));

String itemsModelToJson(List<ItemsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsModel {
  final int userId;
  final int id;
  final String title;
  late final bool completed;

  ItemsModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) => ItemsModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
