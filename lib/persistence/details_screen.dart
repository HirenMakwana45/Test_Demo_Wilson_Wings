import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_html/flutter_html.dart';

import '../model/BlogModel.dart';

class DetailScreen extends StatefulWidget {
  String Title;
  String Description;
  String Image;
  String Video;

  DetailScreen(this.Title, this.Description, this.Image, this.Video,
      {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: Container(
            margin: EdgeInsets.only(left: w * 0.05),
            child: const Text(
              "News Detail Screen ",
              style: TextStyle(color: Colors.white),
            )),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
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
                      top: MediaQuery.of(context).size.height * 0.02,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            widget.Title.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 26),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.005,
                        left: MediaQuery.of(context).size.height * 0.01,
                        right: MediaQuery.of(context).size.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Html(
                            // softWrap: true,
                            data: widget.Description.toString(),
                            style: {
                              '*': Style(
                                color: const Color(0XFFFFFFFF),
                                fontFamily: 'Poppins',
                              ), // Set the default span color
                            },
                            // defaultTextStyle: const TextStyle(
                            //   color: Color(0XFFFFFFFF),
                            //   fontFamily: 'Poppins',
                            // ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: widget.Video.isEmpty
                        ? EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.005,
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02,
                            bottom: MediaQuery.of(context).size.height * 0.02)
                        : EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.005,
                            left: MediaQuery.of(context).size.height * 0.02,
                            right: MediaQuery.of(context).size.height * 0.02),
                    child: Image.network(
                      widget.Image.toString(),
                      // width: 50,
                      // height: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                  widget.Video.isEmpty
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                              left: MediaQuery.of(context).size.height * 0.02,
                              right: MediaQuery.of(context).size.height * 0.02,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: video(widget.Video.toString())),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class SteamsSoket {
  final _stream = StreamController<List<Blog>>.broadcast();
  void Function(List<Blog>) get addresponse => _stream.sink.add;
  Stream<List<Blog>> get getRespones => _stream.stream.asBroadcastStream();
}

class video extends StatefulWidget {
  final String link;
  video(this.link, {Key? key}) : super(key: key);

  @override
  State<video> createState() => _videoState();
}

class _videoState extends State<video> {
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController controller;
  bool visble = true;
  bool _isplay = false;
  String? duretion;

  @override
  void initState() {
    // TODO: implement initState
    controller = VideoPlayerController.network(widget.link);
    _initializeVideoPlayerFuture = controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  getVideoPosition() {
    var duration = Duration(
        milliseconds: controller.value.duration.inMilliseconds.round());
    setState(() {
      duretion = [duration.inHours, duration.inMinutes, duration.inSeconds]
          .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          .join(':');
    });
    return Text(
      [duration.inHours, duration.inMinutes, duration.inSeconds]
          .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
          .join(':'),
      style: const TextStyle(
          color: Color(0XffFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(
          //   height: 30,
          // ),
          GestureDetector(
            onTap: () {
              if (visble == true) {
                setState(() {
                  visble = false;
                });
                print("visiblity:$visble");
              } else {
                setState(() {
                  visble = true;
                });
                print("visiblity:$visble");
              }
            },
            child: Stack(
              children: [
                Center(
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  child: VideoPlayer(controller))),
                        );
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 75.0),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: Visibility(
                    visible: visble,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () {
                                  controller.pause();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0, top: 8),
                                  child: Icon(Icons.fullscreen,
                                      color: Colors.white),
                                )),
                          ),
                          if (controller.value.isPlaying)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        print('FORWARD 10 SECS');
                                        await controller.seekTo(Duration(
                                            seconds: controller
                                                    .value.position.inSeconds -
                                                10));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 8,
                                            top: 8,
                                            left: 24,
                                            right: 8),
                                        child: Icon(Icons.fast_rewind_outlined,
                                            color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          controller.pause();

                                          setState(() {
                                            _isplay = false;
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.pause,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                                        )),
                                    GestureDetector(
                                      onTap: () async {
                                        print('FORWARD 10 SECS');
                                        await controller.seekTo(Duration(
                                            seconds: controller
                                                    .value.position.inSeconds +
                                                10));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 8,
                                            top: 8,
                                            left: 8,
                                            right: 24),
                                        child: Icon(Icons.fast_forward_outlined,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        print('FORWARD 10 SECS');
                                        await controller.seekTo(Duration(
                                            seconds: controller
                                                    .value.position.inSeconds -
                                                10));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 8,
                                            top: 8,
                                            left: 24,
                                            right: 8),
                                        child: Icon(Icons.fast_rewind_outlined,
                                            color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.play();
                                        visble = false;
                                        if (controller.value.position ==
                                            const Duration(
                                                seconds: 0,
                                                minutes: 0,
                                                hours: 0)) {
                                          print(
                                              '************************************************** video Started *************************************************');
                                          // Seen_Video();
                                        }
                                        if (controller.value.position ==
                                            controller.value.duration) {
                                          print(
                                              '************************************************** video Ended *************************************************');
                                        }
                                        if (_isplay == true) {
                                          setState(() {
                                            _isplay = false;
                                          });
                                        } else {
                                          setState(() {
                                            _isplay = true;
                                          });
                                        }
                                      },
                                      child: _isplay
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                            ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        print('FORWARD 10 SECS');
                                        await controller.seekTo(Duration(
                                            seconds: controller
                                                    .value.position.inSeconds +
                                                10));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 8,
                                            top: 8,
                                            left: 8,
                                            right: 24),
                                        child: Icon(Icons.fast_forward_outlined,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8),
                                  child: VideoProgressIndicator(
                                    controller,
                                    allowScrubbing: true,
                                    colors: const VideoProgressColors(
                                        backgroundColor: Colors.black12,
                                        playedColor: Colors.white),
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: controller,
                                builder:
                                    (context, VideoPlayerValue value, child) {
                                  //Do Something with the value.
                                  return Text(
                                      value.position.toString().length > 7
                                          ? "${value.position.toString().substring(0, 7)} / "
                                          : value.position.toString(),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins"));
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: getVideoPosition(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // const SizedBox(
          //   height: 30,
          // ),
        ],
      ),
    );
  }
}
