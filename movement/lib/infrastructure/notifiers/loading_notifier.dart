import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/database/database.dart';
import 'generic_notifier.dart';

class LoadingNotifier extends StateNotifier<NotifierState> {
  final Database _database;

  LoadingNotifier(this._database) : super(const Loading()) {
    isLoggedIn();
  }

  Future isLoggedIn() async {
    final token = await _database.tokensDao.getTokenAsync();
    state = const Loading();
    state = Loaded<bool>(token != null);
  }
}
