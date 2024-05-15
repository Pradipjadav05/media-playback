import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant/paths.dart';
import '../controller/audio_player_controller.dart';
import '../model/recording.dart';
import '../model/recording_group.dart';

part  'files_state.dart';

class FilesCubit extends Cubit<FilesState>{
  FilesCubit() : super(FilesInitial()) {
    getFiles();
  }

  Future<void> getFiles() async {
    List<Recording> recordings = [];
    emit(FilesLoading());
    bool permissionGranted = await Permission.storage.status.isGranted || await Permission.manageExternalStorage.status.isGranted;
    if (permissionGranted) {
      final List<FileSystemEntity> files = Directory(Paths.recording).listSync();

      for (final file in files) {
        AudioPlayerController controller = AudioPlayerController();

        /// Used controller her just to get the duration on file using [setPath()]
        Duration? fileDuration = await controller.setPath(filePath: file.path);
        if (fileDuration != null) {
          recordings.add(Recording(file: file, fileDuration: fileDuration));
        }
      }

      emit(FilesLoaded(recordings: recordings));
    } else {
      emit(FilesPermisionNotGranted());
    }


  }

  removeRecording(Recording recording) {
    final recordings = (state as FilesLoaded)
        .recordings
        .where((element) => element != recording)
        .toList();
    emit(FilesLoaded(recordings: recordings));
  }

}