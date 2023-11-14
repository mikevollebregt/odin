import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin AnimationStoppedMixin {
  void onAnimationEnded(BuildContext context, WidgetRef ref);
}
