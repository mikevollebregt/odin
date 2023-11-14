import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({Key? key}) : super(key: key);

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return !isFinished
        ? Center(
            child: Lottie.asset(
              'assets/animations/confetti.json',
              repeat: false,
              controller: controller,
              onLoaded: (composition) {
                controller
                  ..duration = composition.duration
                  ..forward().whenComplete(() => setState(() => isFinished = true));
              },
            ),
          )
        : Container();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }
}
