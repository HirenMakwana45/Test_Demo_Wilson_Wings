import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testdemo/api/getproductlist_api.dart';
import 'package:testdemo/persistence/details_screen.dart';

import '../model/BlogModel.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Model Declaration
  BlogsModel? _allProducts;

  //Variable Declaration
  bool blogdatacoming = true;
  BlogsModel? _blogsModel;
  String Title = "";
  String Description = "";
  String Imagea = "";
  String Video = "";

  @override
  void initState() {
    setState(() {
      blogapi();
    });
    super.initState();
  }

  // Apicall

  blogapi() {
    setState(() {
      BlogsApi().apiblogs().then((value) {
        setState(() {
          _blogsModel = value;
          blogdatacoming = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Container(
            margin: EdgeInsets.only(left: w * 0.05),
            child: const Text(
              "Home",
              style: TextStyle(color: Colors.white),
            )),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: w * 0.05),
              child: Row(
                children: [
                  Text(
                    "News",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            blogdatacoming
                ? CircularProgressIndicator.adaptive(
                    backgroundColor: Color.fromARGB(255, 111, 192, 128),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _blogsModel!.blogs!.length,
                    itemBuilder: (BuildContext context, int index) {
                      // videonotfound = _blogsModel!.blogs![index].videoUrl.toString();
                      return Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.02),
                        decoration: BoxDecoration(
                          color: Color(0xff128C7E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.02,
                                  left:
                                      MediaQuery.of(context).size.height * 0.02,
                                  right:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            print("Blog Id ==> " +
                                                _blogsModel!
                                                    .blogs![index].webBlogUrl
                                                    .toString());

                                            Title = _blogsModel!
                                                .blogs![index].title
                                                .toString();
                                            Description = _blogsModel!
                                                .blogs![index].description
                                                .toString();

                                            Imagea = _blogsModel!
                                                .blogs![index].imageUrl
                                                .toString();
                                            Video = _blogsModel!
                                                .blogs![index].videoUrl
                                                .toString();

                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: DetailScreen(
                                                        Title,
                                                        Description,
                                                        Imagea,
                                                        Video)));
                                          });
                                        },
                                        child: Text(
                                          _blogsModel!.blogs![index].title
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  26),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
