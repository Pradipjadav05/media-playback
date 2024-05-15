
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';


import '../constant/paths.dart';
import '../constant/recorder_constant.dart';
part 'record_state.dart';

class RecordCubit extends Cubit<RecordState>{
  RecordCubit() : super(RecordInitial());

  final AudioRecorder _audioRecorder = AudioRecorder();


  void startRecording() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();


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

    await Permission.microphone.status.isDenied.then((value) {
      if(value){
        Permission.microphone.request();
      }
    });


    bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
        permissions[Permission.microphone]!.isGranted;

    if (true) {
      Directory appFolder = Directory(Paths.recording);
      bool appFolderExists = await appFolder.exists();
      if (!appFolderExists) {
        final created = await appFolder.create(recursive: true);
        print(created.path);
      }

      final filepath = '${Paths.recording}/${DateTime.now().millisecondsSinceEpoch}.${RecorderConstants.fileExtention}';
      print(filepath);
      const config = RecordConfig();

      await _audioRecorder.start(config, path: filepath);

      emit(RecordOn());

    } else {
      print('Permissions not granted');
    }
  }

  void stopRecording() async {
    String? path = await _audioRecorder.stop();
    emit(RecordStopped());
    print('Output path $path');
  }

  Future<Amplitude> getAmplitude() async {
    final amplitude = await _audioRecorder.getAmplitude();
    return amplitude;
  }


  Stream<double> aplitudeStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: RecorderConstants.amplitudeCaptureRateInMilliSeconds));
      final ap = await _audioRecorder.getAmplitude();
      yield ap.current;
    }
  }

}