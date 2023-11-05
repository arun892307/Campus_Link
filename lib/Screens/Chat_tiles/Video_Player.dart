import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.path, required this.thumbnail});
  final File path;
  final File thumbnail;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.path);
    videoPlayerController.initialize().then((value) {
      if(mounted){
        setState(() {
          print("Initialized");
        });
      }
    });
  }
  bool playing=false;
  bool resume=false;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(

      color: Colors.black54,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          onPressed: (){
            Navigator.pop(context);
            },
          child: const Icon(Icons.clear,color: Colors.white,),
        ),
        body: Center(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: (playing || resume) ?
            BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Colors.black, width: 2))
                :
            BoxDecoration(
                image: DecorationImage(
                    image: FileImage(widget.thumbnail),
                    fit: BoxFit.contain),
                color: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Colors.black, width: 2)),
            child: playing
                ?
            videoPlayerController.value.isInitialized
                ?
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                ),
                resume
                    ?
                IconButton(
                  onPressed: () async {
                    setState(() {
                      resume=false;
                      if(videoPlayerController.value.duration == videoPlayerController.value.position){
                        videoPlayerController.initialize();
                      }

                      videoPlayerController.play();

                    });
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.play_arrow ,
                      color: Colors.white,
                    ),
                  ),
                )
                    :
                IconButton(
                  onPressed: () {
                    videoPlayerController.pause();

                    setState(() {
                      resume=true;
                      if(videoPlayerController.value.duration == videoPlayerController.value.position){
                        videoPlayerController.initialize();
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
                :
            const Center(child: CircularProgressIndicator())
                :
            IconButton(
              onPressed: () async {
                setState(() {
                  playing=true;
                  //videoPlayerController.setLooping(true);
                  resume=false;

                });
                videoPlayerController = VideoPlayerController.file(widget.path);
                await videoPlayerController.initialize().then((value) {
                  if (mounted) {
                    setState(() {
                      print("Initialized-------------------------------------------------");
                      videoPlayerController.play();
                    });
                  }
                });
                if(videoPlayerController.value.duration == videoPlayerController.value.position){
                  videoPlayerController.initialize();
                }
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
        ),
      ),
    );
  }
}
