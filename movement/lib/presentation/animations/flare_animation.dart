import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import 'animation_stopped_mixin.dart';

class FlareAnimationWidget extends ConsumerWidget {
  final AnimationStoppedMixin delegate;

  const FlareAnimationWidget({required this.delegate});

  void onAnimationCompleted(String name, BuildContext context, WidgetRef ref) {
    delegate.onAnimationEnded(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250 * y,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(width: 0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: 250 * y,
                child: FlareActor(
                  'assets/animations/daycomplete_bin.flr',
                  fit: BoxFit.scaleDown,
                  callback: (name) => {onAnimationCompleted(name, context, ref)},
                  animation: 'Checkmark Appear',
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
