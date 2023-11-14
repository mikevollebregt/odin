import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/main.dart';
import 'package:movement/presentation/pages/settings/support_page.dart';

import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../infrastructure/repositories/log_repository.dart';
import '../../providers.dart';
import '../menu/menu_widget.dart';
import '../pages/introduction/introduction_page.dart';
import '../pages/location_search_page.dart';
import '../pages/login_page.dart';
import '../pages/movement_details/movement_details_page.dart';
import '../pages/movement_details/select_vehicle_page.dart';
import '../pages/stop_details/select_reason_page.dart';
import '../pages/stop_details/stop_details_page.dart';

class Routes {
  static const String introPage = 'introductionPage';
  static const String menuWidget = 'menuWidget';
  static const String locationSearchPage = 'locationSearchPage';
  static const String stopReasonPage = 'stopReasonPage';
  static const String movementVehiclePage = 'movementVehiclePage';
  static const String movementDetailsPage = 'movementDetailsPage';
  static const String stopDetailsPage = 'stopDetailsPage';
  static const String loginPage = 'loginPage';
  static const String supportPage = 'supportPage';

  static void RouteToPage(
    String routePath,
    BuildContext context, {
    WidgetRef? ref,
    StopDto? stopDto,
    MovementDto? movementDto,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    switch (routePath) {
      case introPage:
        Navigator.pushReplacement<void, void>(context, MaterialPageRoute(builder: (context) {
          log('Routes::intro_page', '', LogType.Flow);
          return IntroductionPage();
        }));
        break;
      case menuWidget:
        Navigator.pushReplacement<void, void>(context, MaterialPageRoute(builder: (context) {
          log('Routes::menu_widget', '', LogType.Flow);
          return MenuWidget();
        }));
        break;
      case locationSearchPage:
        Navigator.push<void>(context, MaterialPageRoute<dynamic>(builder: (context) {
          log('Routes::location_search', '', LogType.Flow);
          return LocationSearchPage(stopDto!);
        }));
        break;
      case stopReasonPage:
        Navigator.push<void>(context, MaterialPageRoute(builder: (context) {
          log('Routes::select_stop_reason', 'id: ${stopDto?.stopUuid}', LogType.Flow);
          return SelectReasonPage(stopDto!);
        }));
        break;
      case movementVehiclePage:
        Navigator.push<void>(context, MaterialPageRoute(builder: (context) {
          log('Routes::select_vehicle', 'id: ${movementDto?.movementUuid}', LogType.Flow);
          return SelectVehiclePage(movementDto!);
        }));
        break;
      case stopDetailsPage:
        if (stopDto == null) {
          final trackedDayUuid = await ref!.read(trackedDayRepository).getTrackedDayUuid(startDate!);
          stopDto = StopDto.userCreate(startDate, endDate!, trackedDayUuid!);
        }
        Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (_) {
              log('Routes::stopDetailsPage', 'id: ${stopDto?.stopUuid}', LogType.Flow);
              return StopDetailsPage(stopDto!);
            },
          ),
        );
        break;
      case movementDetailsPage:
        if (movementDto == null) {
          //TODO: use container.read instead of ref!.read, such that navigation has less ambigious requirements? (for all occurences in file)
          final trackedDayUuid = await ref!.read(trackedDayRepository).getTrackedDayUuid(startDate!);
          movementDto = MovementDto.userCreate(startDate, endDate!, trackedDayUuid!);
        }
        Navigator.push<void>(
          context,
          MaterialPageRoute(
            builder: (_) {
              log('Routes::movementDetailsPage', 'id: ${movementDto?.movementUuid}', LogType.Flow);
              return MovementDetailsPage(movementDto!);
            },
          ),
        );
        break;
      case supportPage:
        container.read(supportNotifierProvider).updateSensorStats();
        container.read(supportNotifierProvider).updateSensorsAreRunning();
        Navigator.push<void>(context, MaterialPageRoute(builder: (context) {
          log('Routes::login_page', '', LogType.Flow);
          return SupportPage();
        }));
        break;
      case loginPage:
        Navigator.pushReplacement<void, void>(context, MaterialPageRoute(builder: (context) {
          log('Routes::login_page', '', LogType.Flow);
          return LoginPage();
        }));
        break;

      default:
        throw 'This route name does not exit';
    }
  }
}
