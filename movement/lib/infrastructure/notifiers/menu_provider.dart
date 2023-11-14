import 'package:flutter/material.dart';

import '../repositories/dtos/enums/log_type.dart';
import '../repositories/log_repository.dart';

class MenuNotifier extends ChangeNotifier {
  //final SyncNotifier _syncNotifier;

  MenuNotifier();

  final controller = PageController();
  int get currentPage => _currentPage;
  bool get shouldDisplayFAB => _currentPage == 1;

  int _currentPage = 0;

  Future<void> setPage(int page) async {
    await log('MenuWidget::onPageChanged', page.toString(), LogType.Flow);

    _currentPage = page;
    notifyListeners();
    controller.jumpToPage(page);
  }
}
