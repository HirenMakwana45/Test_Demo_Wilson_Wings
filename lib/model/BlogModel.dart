// To parse this JSON data, do
//
//     final blogsModel = blogsModelFromJson(jsonString);

import 'dart:convert';

BlogsModel blogsModelFromJson(String str) =>
    BlogsModel.fromJson(json.decode(str));

String blogsModelToJson(BlogsModel data) => json.encode(data.toJson());

class BlogsModel {
  List<Blog>? blogs;

  BlogsModel({
    this.blogs,
  });

  factory BlogsModel.fromJson(Map<String, dynamic> json) => BlogsModel(
        blogs: List<Blog>.from(json["blogs"].map((x) => Blog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "blogs": List<dynamic>.from(blogs!.map((x) => x.toJson())),
      };
}

class Blog {
  String? id;
  String? title;
  String? description;
  String? imageName;
  String? imageUrl;
  String? videoName;
  String? videoUrl;
  DateTime? cdate;
  String? webBlogUrl;

  Blog({
    this.id,
    this.title,
    this.description,
    this.imageName,
    this.imageUrl,
    this.videoName,
    this.videoUrl,
    this.cdate,
    this.webBlogUrl,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imageName: json["image_name"],
        imageUrl: json["image_Url"],
        videoName: json["video_name"],
        videoUrl: json["video_Url"],
        cdate: DateTime.parse(json["cdate"]),
        webBlogUrl: json["web_blog_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image_name": imageName,
        "image_Url": imageUrl,
        "video_name": videoName,
        "video_Url": videoUrl,
        "cdate": cdate!.toIso8601String(),
        "web_blog_url": webBlogUrl,
      };
}
