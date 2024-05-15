import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Sound_Recorder/constant/app_color.dart';
import '../Sound_Recorder/constant/paths.dart';
import '../Sound_Recorder/constant/recorder_constant.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File? _image;
  final picker = ImagePicker();

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
                await getImageFromCamera();
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
                      " Capture Image",
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
              " Display Image",
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
              child: _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.contain,
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
                await getImageFromGallery();
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
        'Image Capture & Display',
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

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {

    await Permission.storage.status.isDenied.then((value) {
      if(value){
        Permission.storage.request();
      }
    });

    await Permission.manageExternalStorage.status.isDenied.then((value) {
      if(value){
        Permission.manageExternalStorage.request();
      }
    });

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }

    Directory appFolder = Directory(Paths.image);
    bool appFolderExists = await appFolder.exists();
    if (!appFolderExists) {
      final created = await appFolder.create(recursive: true);
      print(created.path);
    }

    final filepath = '${Paths.image}/${DateTime.now().millisecondsSinceEpoch}.${RecorderConstants.imageFileExtention}';
    print("Video file path: $filepath");

    await _image!.copy(filepath);

    setState(() {});
  }
}
