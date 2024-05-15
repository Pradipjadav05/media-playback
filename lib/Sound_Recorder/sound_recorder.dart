import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constant/app_color.dart';
import 'constant/concave_decoration.dart';
import 'constant/recorder_constant.dart';
import 'cubit/file_cubit.dart';
import 'cubit/record_cubit.dart';
import 'recording_list_screen.dart';
import 'widget/audio_visualizer.dart';
import 'widget/mic.dart';

// https://github.com/Manty-K/Rapid-Note

class SoundRecorder extends StatelessWidget {
  const SoundRecorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<RecordCubit, RecordState>(
        builder: (context, state) {
          if (state is RecordStopped || state is RecordInitial) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  appTitle(),
                  const Spacer(),
                  NeumorphicMic(onTap: () {
                    context.read<RecordCubit>().startRecording();
                  }),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, _customRoute());
                    },
                    child: myNotes(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            );
          } else if (state is RecordOn) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  appTitle(),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      StreamBuilder<double>(
                        initialData: RecorderConstants.decibleLimit,
                        stream: context.read<RecordCubit>().aplitudeStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AudioVisualizer(amplitude: snapshot.data);
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Visualizer failed to load',
                              style: TextStyle(color: AppColors.accentColor),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.read<RecordCubit>().stopRecording();

                      ///We need to refresh [FilesState] after recording is stopped
                      context.read<FilesCubit>().getFiles();
                    },
                    child: Container(
                      decoration: ConcaveDecoration(
                        shape: const CircleBorder(),
                        depression: 10,
                        colors: const [
                          AppColors.highlightColor,
                          AppColors.shadowColor,
                        ],
                      ),
                      height: 100,
                      width: 100,
                      child: const Icon(
                        Icons.stop,
                        color: AppColors.accentColor,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],

              ),
            );
          } else {
            return const Center(
              child: Text(
                'An Error occurred',
                style: TextStyle(color: AppColors.accentColor),
              ),
            );
          }
        },
      ),
    );
  }

  Widget appTitle() {
    return Text(
      'Recorder',
      style: TextStyle(
        color: AppColors.accentColor,
        fontSize: 50,
        letterSpacing: 5,
        fontWeight: FontWeight.w200,
        shadows: [
          Shadow(
              offset: const Offset(3, 3),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.2)),
        ],
      ),
    );
  }

  Text myNotes() {
    return Text(
      'MY RECORDINGS',
      style: TextStyle(
        color: AppColors.accentColor,
        fontSize: 20,
        letterSpacing: 5,
        shadows: [
          Shadow(
              offset: const Offset(3, 3),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.2)),
        ],
        // decoration: TextDecoration.underline,
      ),
    );
  }

  Route _customRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RecordingsListScreen(),
    );
  }
}
