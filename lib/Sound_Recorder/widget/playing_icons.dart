import 'package:flutter/material.dart';

import '../constant/app_color.dart';

class PlayingIcon extends StatefulWidget {
  final bool idle;

  const PlayingIcon({super.key, this.idle = false});

  factory PlayingIcon.idle() {
    return const PlayingIcon(idle: true);
  }

  @override
  State<PlayingIcon> createState() => _PlayingIconState();
}

class _PlayingIconState extends State<PlayingIcon>  with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;
  double maxHeight = 50;

  bool forwardDirection = true;

  List<double> offsetArray = [
    0.0,
    0.1,
    0.2,
    0.3,
    0.4,
    0.5,
    0.5,
    0.7,
    0.8,
    0.9
  ];

  @override
  void initState() {
    super.initState();
    offsetArray.shuffle();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
          setState(() {
            forwardDirection = false;
          });
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
          setState(() {
            forwardDirection = true;
          });
        }
      })
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: offsetArray.map((offset) => _bar(offset)).toList());
  }

  Widget _bar(double offset) {
    var value = animation.value;
    var off = 0.0;

    if (forwardDirection) {
      off = value + offset;
      if (off > 1) {
        off -= 1;
      }
    } else {
      off = value - offset;
      if (off < 0) {
        off += 1;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: !widget.idle ? off * maxHeight : 5,
        width: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.accentColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}
