import 'package:flutter/material.dart';
import 'package:media_playback/Sound_Recorder/constant/app_color.dart';

import '../constant/recorder_constant.dart';

class AudioVisualizer extends StatelessWidget {
  final double? amplitude;
  final double maxHeight = 100;
  late double range;

  AudioVisualizer({super.key, required this.amplitude}){
    ///limit amplitude to [decibleLimit]
    double db = amplitude ?? RecorderConstants.decibleLimit;
    if (db == double.infinity || db < RecorderConstants.decibleLimit) {
      db = RecorderConstants.decibleLimit;
    }
    if (db > 0) {
      db = 0;
    }

    ///this expression converts [db] to [0 to 1] double
    range = 1 - (db * (1 / RecorderConstants.decibleLimit));
    print(range);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildBar(0.15),
        buildBar(0.5),
        buildBar(0.25),
        buildBar(0.75),
        buildBar(0.5),
        buildBar(1),
        buildBar(0.75),
        buildBar(0.5),
        buildBar(0.25),
        buildBar(0.5),
        buildBar(0.15),
      ],
    );
  }

  buildBar(double intensity) {
    double barHeight = range * maxHeight * intensity;
    if (barHeight < 5) {
      barHeight = 5;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: RecorderConstants.amplitudeCaptureRateInMilliSeconds,),
        height: barHeight,
        width: 5,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            const BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: 1,
              offset: Offset(1, 1),
            ),
            BoxShadow(
              color: AppColors.highlightColor,
              spreadRadius: 1,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
      ),
    );
  }
}
