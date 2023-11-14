import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/enums/app_theme.dart';
import 'generic_notifier.dart';

class ThemeNotifier extends StateNotifier<NotifierState> {
  ThemeNotifier() : super(const Loaded(AppTheme.StandardTheme));

  Future<void> setTheme(AppTheme theme) async {
    try {
      state = const Loading();

      state = Loaded(theme);
    } on Exception {
      state = const Error("Couldn't set theme.");
    }
  }
}
