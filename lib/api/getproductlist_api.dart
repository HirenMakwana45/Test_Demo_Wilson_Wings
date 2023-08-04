// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/BlogModel.dart';

class BlogsApi {
  Future<BlogsModel> apiblogs() async {
    var url = Uri.parse(
        'https://dreamcatcherbykashish.com/mahadevpan/Apis/fetch_blog.php');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    });

    Encoding.getByName('utf-8');

    Map<String, dynamic> map = await jsonDecode(response.body);

    print(response.body);

    final data = BlogsModel.fromJson(map);
    return data;
  }
}
