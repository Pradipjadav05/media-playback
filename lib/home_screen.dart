import 'package:flutter/material.dart';
import 'package:media_playback/Image_capture_and_show/image_screen.dart';
import 'package:media_playback/Sound_Recorder/constant/app_color.dart';
import 'package:media_playback/Sound_Recorder/sound_recorder.dart';

import 'video_capture_and_display/video_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media Playback", style: TextStyle(color: AppColors.accentColor),),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: AppColors.accentColor,
              child: ListTile(
                title: const Text("Sound Recorder"),
                leading: const Icon(Icons.multitrack_audio),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SoundRecorder(),));
                },
              ),
            ),
            Card(
              color: AppColors.accentColor,
              child: ListTile(
                title: const Text("Image Capture & show"),
                leading: const Icon(Icons.photo_album),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ImageScreen(),));
                },
              ),
            ),
            Card(
              color: AppColors.accentColor,
              child: ListTile(
                title: const Text("Video Capture & Play"),
                leading: const Icon(Icons.videocam_sharp),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoScreen(),));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
