import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'Video_Player.dart';

class VideoTile extends StatefulWidget {
  const VideoTile(
      {super.key,
      required this.channel,
      required this.videoURL,
      required this.videoThumbnailURL,
      required this.stamp});
  final String channel;
  final String videoURL;
  final String videoThumbnailURL;
  final DateTime stamp;

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController videoPlayerController;
  double x = 8, y = 8;
  double percent = 0;
  bool downloadedThumbnail = false;
  bool downloadedVideo = false;
  bool isDownloading = false;
  File thumbnailPath = File("");
  File videoPath = File("");
  bool resume = false;
  final dio = Dio();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    check();
  }

  bool playing = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.01,
        ),
        downloadedVideo
            ? InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return VideoPlayerScreen(
                        path: videoPath,
                        thumbnail: thumbnailPath,
                      );
                    },
                  ));
                },
                child: Container(
                  width: double.maxFinite,
                  height: size.height * 0.3,
                  decoration: (playing || resume)
                      ?
                  BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.black, width: 2))
                      :
                  BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          image: DecorationImage(
                              image: FileImage(thumbnailPath),
                              fit: BoxFit.contain),
                          color: Colors.black,
                          border: Border.all(color: Colors.black, width: 2)),
                  child: playing
                      ? Container(
                          color: Colors.transparent,
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: videoPlayerController.value.isInitialized
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: videoPlayerController
                                          .value.aspectRatio,
                                      child: VideoPlayer(videoPlayerController),
                                    ),
                                    resume
                                        ? IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                resume = false;
                                                if (videoPlayerController
                                                        .value.duration ==
                                                    videoPlayerController
                                                        .value.position) {
                                                  videoPlayerController
                                                      .initialize();
                                                }

                                                videoPlayerController.play();
                                              });
                                            },
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.black54,
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              videoPlayerController.pause();

                                              setState(() {
                                                resume = true;
                                                if (videoPlayerController
                                                        .value.duration ==
                                                    videoPlayerController
                                                        .value.position) {
                                                  videoPlayerController
                                                      .initialize();
                                                }
                                              });
                                            },
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.black54,
                                              child: Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator()),
                        )
                      : IconButton(
                          onPressed: () async {
                            setState(() {
                              playing = true;
                              resume = false;
                            });
                            videoPlayerController =
                                VideoPlayerController.file(videoPath);
                            await videoPlayerController
                                .initialize()
                                .then((value) {
                              if (mounted) {
                                setState(() {
                                  print(
                                      "Initialized-------------------------------------------------");
                                  videoPlayerController.play();
                                });
                              }
                            });
                            if (videoPlayerController.value.duration ==
                                videoPlayerController.value.position) {
                              videoPlayerController.initialize();
                            }
                            videoPlayerController.setLooping(true);
                          },
                          icon: const CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              )
            : downloadedThumbnail
                ? ClipRect(
                    child: Container(
                      width: size.width * 0.55,
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(thumbnailPath),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: x, sigmaY: y),
                        child: SizedBox(
                          child: isDownloading
                              ? CircularPercentIndicator(
                                  percent: percent,
                                  radius: size.width * 0.08,
                                  animation: true,
                                  animateFromLastPercent: true,
                                  curve: accelerateEasing,
                                  progressColor: Colors.green,
                                  center: Text(
                                      "${(percent * 100).toStringAsFixed(2)}%"),
                                  footer: const Text("Downloading"),
                                  backgroundColor: Colors.transparent,
                                )
                              : IconButton(
                                  onPressed: () {
                                    downloadVideo();
                                    setState(() {
                                      isDownloading = true;
                                    });
                                  },
                                  icon: const Icon(Icons.download)),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
      ],
    );
  }

  check() async {
    Directory? directory = await getApplicationSupportDirectory();

    String additionalPath = "/videos";
    String additionalPath1 = "/thumbnail";
    thumbnailPath =
        File("${directory.path}$additionalPath1/${widget.stamp}.png");
    directory = Directory("${directory.path}$additionalPath");
    videoPath = File("${directory.path}/${widget.stamp}.mp4");
    if (await videoPath.exists()) {
      print("image exist original");
      setState(() {
        downloadedVideo = true;
      });
    } else {
      print("original not exist");
      directory = await getApplicationSupportDirectory();
      additionalPath = "/thumbnail";
      directory = Directory("${directory.path}$additionalPath");

      if (directory.existsSync()) {
        print("Directory exist");
      } else {
        print("thumbnail not exist");
        await directory.create();
      }

      thumbnailPath = File("${directory.path}/${widget.stamp}.png");

      if (await thumbnailPath.exists()) {
        print("image exist thumbnail image");
        setState(() {
          downloadedThumbnail = true;
        });
      } else {
        print("Downloading thumbnail");
        await dio.download(
          widget.videoThumbnailURL,
          thumbnailPath.path,
          onReceiveProgress: (count, total) {
            if (count == total) {
              setState(() {
                print("downloadedThumbnail set to true");
                downloadedThumbnail = true;
              });
            }
          },
        );
      }
      print(downloadedThumbnail);
      print(thumbnailPath);
    }
  }

  downloadVideo() async {
    Directory directory = await getApplicationSupportDirectory();
    String additionalPath = "/videos";
    directory = Directory("${directory.path}$additionalPath");

    if (directory.existsSync()) {
      print("Directory exist");
    } else {
      await directory.create();
    }

    File _videoPath = File("${directory.path}/${widget.stamp}.mp4");

    await dio.download(
      widget.videoURL,
      _videoPath.path,
      onReceiveProgress: (count, total) {
        if (count == total) {
          setState(() {
            videoPlayerController = VideoPlayerController.file(_videoPath);
            videoPlayerController.initialize().then((value) {
              if (mounted) {
                setState(() {
                  print("Initialized");
                });
              }
            });
            videoPath = _videoPath;
            x = 0;
            y = 0;
            downloadedVideo = true;
          });
        } else {
          setState(() {
            isDownloading = true;
            percent = (count / total);
          });
        }
      },
    );
  }
}
