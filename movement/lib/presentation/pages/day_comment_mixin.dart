import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin DayCommentMixin {
  void onDayComment(
    BuildContext context,
    String text,
    int choice,
    WidgetRef ref,
  );
}
