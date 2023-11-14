import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../color_pallet.dart';
import '../../infrastructure/notifiers/responsive_ui.dart';
import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/log_repository.dart';
import '../../infrastructure/services/device_service.dart';
import '../../main.dart';
import '../../providers.dart';
import '../pages/calendar_page_adapter.dart';
import '../pages/day_overview/day_overview_page.dart';
import '../pages/settings/settings_page.dart';

class MenuWidget extends ConsumerWidget {
  final _pages = <Widget>[CalendarPageAdapter(), DayOverviewPage(), SettingsPage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('MenuWidget::build', '', LogType.Flow);
    final menuNotifier = ref.watch(menuNotifierProvider);
    final calendarNotifier = ref.watch(calendarPageNotifierProvider.notifier);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(0), child: Container()),
      // floatingActionButton: menuNotifier.shouldDisplayFAB ? const FancyFab() : null,
      backgroundColor: ColorPallet.primaryColor,
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            showUnselectedLabels: true,
            currentIndex: menuNotifier.currentPage,
            onTap: (index) {
              menuNotifier.setPage(index);
              log('MenuWidget::onTapBottomNavigationbar', 'index:' + index.toString(), LogType.Flow);
              container.read(syncNotifierProvider).sync();
              calendarNotifier.loadCalendarPageDayDataList();
              if (index == 1) DeviceService().addSensorLocation();
            },
            items: [
              BottomNavigationBarItem(
                label: 'Kalender',
                icon: Icon(Icons.calendar_today_rounded, size: 30 * f),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_sharp, size: 30 * f),
                label: 'Mijn tijdlijn',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, size: 30 * f),
                label: 'Instellingen',
              )
            ],
          );
        },
      ),
      body: PageView.builder(
        controller: menuNotifier.controller,
        itemCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _pages[menuNotifier.currentPage];
        },
      ),
    );
  }
}
