import 'dart:convert';

List<PostData> postDataFromJson(String str) => List<PostData>.from(json.decode(str).map((x) => PostData.fromJson(x)));

String postDataToJson(List<PostData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostData {
  String name;
  String id;
  String title;
  String description;
  String timestamp;
  
  PostData({
    this.name,
    this.id,
    this.title,
    this.description,
    this.timestamp,
  });
  
  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
    name: json["name"],
    id: json["id"],
    title: json["title"],
    description: json["description"],
    timestamp:json["timestamp"],
  );
  
  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "title": title,
    "description": description,
    "timestamp": timestamp,
  };
}
