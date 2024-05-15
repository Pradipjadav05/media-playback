import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../Sound_Recorder/constant/app_color.dart';
import '../Sound_Recorder/constant/paths.dart';
import '../Sound_Recorder/constant/recorder_constant.dart';

//https://medium.com/go-with-flutter/record-and-play-video-in-flutter-431100d5f7bf

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  File? _video;
  final picker = ImagePicker();
  VideoPlayerController? videoPlayerController;
  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            appTitle(),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {
                await getVideoFromCamera();
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.highlightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera,
                      color: AppColors.accentColor,
                      size: 25,
                    ),
                    Text(
                      " Capture Video",
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 20,
                        letterSpacing: 3,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Text(
              " Play Video",
              style: TextStyle(
                color: AppColors.accentColor,
                fontSize: 20,
                letterSpacing: 3,
              ),
            ),
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.highlightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: _video != null
                  ? Stack(
                      children: [
                        VideoPlayer(videoPlayerController!),
                        isPlay
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoPlayerController!.pause();
                                    isPlay = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.pause,
                                  color: Colors.red,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    videoPlayerController!.play();
                                    isPlay = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.red,
                                ),
                              ),
                        VideoProgressIndicator(
                          videoPlayerController!,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            backgroundColor: AppColors.mainColor,
                            playedColor: AppColors.accentColor,
                            bufferedColor: Colors.green,
                          ),
                        ),

                      ],
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.accentColor,
                        ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {
                await getVideoFromGallery();
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.highlightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo,
                      color: AppColors.accentColor,
                      size: 25,
                    ),
                    Text(
                      " From Gallery",
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 20,
                        letterSpacing: 3,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appTitle() {
    return Center(
      child: Text(
        'Video Capture & Display',
        style: TextStyle(
          color: AppColors.accentColor,
          fontSize: 18,
          letterSpacing: 5,
          fontWeight: FontWeight.w200,
          shadows: [
            Shadow(
                offset: const Offset(3, 3),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.2)),
          ],
        ),
      ),
    );
  }

  //Video Picker function to get image from gallery
  Future getVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    final filePath = pickedFile!.path;

    if (pickedFile != null) {
      _video = File(filePath);
    }

    videoPlayerController = VideoPlayerController.file(File(filePath));

    await videoPlayerController!.initialize().then((value) {
      isPlay = true;
      videoPlayerController!.play();
      // videoPlayerController!.setVolume(0.0);
    });

    setState(() {});
  }

  //Video Picker function to get image from camera
  Future getVideoFromCamera() async {
    await Permission.storage.status.isDenied.then((value) {
      if (value) {
        Permission.storage.request();
      }
    });

    await Permission.manageExternalStorage.status.isDenied.then((value) {
      if (value) {
        Permission.manageExternalStorage.request();
      }
    });

    final pickedFile = await picker.pickVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      _video = File(pickedFile.path);
    }

    Directory appFolder = Directory(Paths.video);
    bool appFolderExists = await appFolder.exists();
    if (!appFolderExists) {
      final created = await appFolder.create(recursive: true);
      print(created.path);
    }

    final filepath =
        '${Paths.video}/${DateTime.now().millisecondsSinceEpoch}.${RecorderConstants.videoFileExtention}';
    print("Video file path: $filepath");

    await _video!.copy(filepath);

    videoPlayerController = VideoPlayerController.file(File(filepath));
    await videoPlayerController!.initialize().then((value) {
      isPlay = true;
      videoPlayerController!.play();
      // videoPlayerController!.setVolume(0.0);
    });
    setState(() {});
  }
}
