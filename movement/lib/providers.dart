import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/support_notifier.dart';
import 'package:movement/infrastructure/notifiers/version_notifier.dart';
import 'package:movement/infrastructure/repositories/database/cache/google_maps_cache.dart';
import 'package:movement/infrastructure/repositories/google_maps_repository.dart';
import 'package:movement/infrastructure/repositories/manual_geolocation_repository.dart';
import 'package:movement/infrastructure/repositories/movement_repository.dart';
import 'package:movement/infrastructure/repositories/network/movement_api.dart';
import 'package:movement/infrastructure/repositories/network/questionnaire_api.dart';
import 'package:movement/infrastructure/repositories/network/stop_api.dart';
import 'package:movement/infrastructure/repositories/questionnaire_repository.dart';
import 'package:movement/infrastructure/repositories/stop_repository.dart';

import 'infrastructure/notifiers/auth_notifier.dart';
import 'infrastructure/notifiers/calendar_page_notifier.dart';
import 'infrastructure/notifiers/day_overview_notifier.dart';
import 'infrastructure/notifiers/device_notifier.dart';
import 'infrastructure/notifiers/generic_notifier.dart';
import 'infrastructure/notifiers/intro_battery_notifier.dart';
import 'infrastructure/notifiers/intro_location_notifier.dart';
import 'infrastructure/notifiers/intro_notification_notifier.dart';
import 'infrastructure/notifiers/loading_notifier.dart';
import 'infrastructure/notifiers/location_search_page_notifier.dart';
import 'infrastructure/notifiers/location_service_notifier.dart';
import 'infrastructure/notifiers/menu_provider.dart';
import 'infrastructure/notifiers/movement_notifier.dart';
import 'infrastructure/notifiers/movement_page_notifier.dart';
import 'infrastructure/notifiers/settings_notifier.dart';
import 'infrastructure/notifiers/stop_classifier_notifier.dart';
import 'infrastructure/notifiers/stop_notifier.dart';
import 'infrastructure/notifiers/sync_notifier.dart';
import 'infrastructure/notifiers/theme_notifier.dart';
import 'infrastructure/repositories/classified_period_repository.dart';
import 'infrastructure/repositories/database/database.dart';
import 'infrastructure/repositories/device_repository.dart';
import 'infrastructure/repositories/dtos/movement_dto.dart';
import 'infrastructure/repositories/dtos/stop_dto.dart';
import 'infrastructure/repositories/error_log_repository.dart';
import 'infrastructure/repositories/localization_repository.dart';
import 'infrastructure/repositories/log_repository.dart';
import 'infrastructure/repositories/network/auth_api.dart';
import 'infrastructure/repositories/network/classified_period_api.dart';
import 'infrastructure/repositories/network/device_api.dart';
import 'infrastructure/repositories/network/error_log_api.dart';
import 'infrastructure/repositories/network/googlemaps_api.dart';
import 'infrastructure/repositories/network/log_api.dart';
import 'infrastructure/repositories/network/manual_geolocation_api.dart';
import 'infrastructure/repositories/network/reason_api.dart';
import 'infrastructure/repositories/network/sensor_geolocation_api.dart';
import 'infrastructure/repositories/network/tracked_api.dart';
import 'infrastructure/repositories/network/tracker_api.dart';
import 'infrastructure/repositories/network/vehicle_api.dart';
import 'infrastructure/repositories/reason_repository.dart';
import 'infrastructure/repositories/sensor_repository.dart';
import 'infrastructure/repositories/tracked_day_repository.dart';
import 'infrastructure/repositories/vehicle_repository.dart';
import 'infrastructure/services/device_service.dart';
import 'infrastructure/services/foreground_service.dart';
import 'infrastructure/services/local_notification_service.dart';
import 'infrastructure/services/sensor_service.dart';

//Notifiers

final stopNotifierProvider = ChangeNotifierProvider.autoDispose.family<StopNotifier, StopDto>(
    (ref, dto) => StopNotifier(ref.watch(stopRepository), ref.watch(classifiedPeriodRepository), ref.watch(reasonRepository), dto));

final movementNotifierProvider = ChangeNotifierProvider.autoDispose.family<MovementNotifier, MovementDto>(
    (ref, dto) => MovementNotifier(ref.watch(movementRepository), ref.watch(classifiedPeriodRepository), ref.watch(vehicleRepository), dto));

final loadingNotifierProvider = StateNotifierProvider<LoadingNotifier, NotifierState>(
  (ref) => LoadingNotifier(ref.watch(database)),
);

final searchPageNotifierProvider = StateNotifierProvider<LocationSearchPageNotifier, NotifierState>(
  (ref) => LocationSearchPageNotifier(ref.watch(googleMapsRepository), ref.watch(deviceServiceProvider)),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, NotifierState>(
  (ref) => AuthNotifier(ref.watch(authApi), ref.watch(database), ref.watch(loadingNotifierProvider.notifier), ref.watch(deviceRepository)),
);

final dayOverviewNotifierProvider =
    ChangeNotifierProvider((ref) => DayOverviewNotifier(ref.watch(trackedDayRepository), ref.watch(classifiedPeriodRepository)));

final movementPageNotifierProvider = ChangeNotifierProvider(
  (ref) => MovementPageNotifier(
    ref.watch(trackedDayRepository),
  ),
);

final supportNotifierProvider = ChangeNotifierProvider((ref) => SupportNotifier(ref.watch(sensorRepository)));

final calendarPageNotifierProvider =
    ChangeNotifierProvider((ref) => CalendarPageNotifier(ref.watch(trackedDayRepository), ref.watch(foregroundServiceProvider)));

final deviceNotifierProvider = StateNotifierProvider<DeviceNotifier, dynamic>(
  (ref) => DeviceNotifier(ref.watch(deviceServiceProvider)),
);

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, NotifierState>(
  (ref) => ThemeNotifier(),
);

final menuNotifierProvider = ChangeNotifierProvider(
  (ref) => MenuNotifier(),
);

final syncNotifierProvider = ChangeNotifierProvider(
  (ref) => SyncNotifier(ref.watch(sensorRepository)),
);

final introLocationNotifierProvider = ChangeNotifierProvider(
  (ref) => IntroLocationNotifier(),
);

final introBatteryNotifierProvider = ChangeNotifierProvider(
  (ref) => IntroBatteryNotifier(),
);

final introNotificationNotifierProvider = ChangeNotifierProvider(
  (ref) => IntroNotificationsNotifier(),
);

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, NotifierState>(
  (ref) => SettingsNotifier(
    ref.watch(foregroundServiceProvider),
    ref.watch(authNotifierProvider.notifier),
    ref.watch(sensorRepository),
  ),
);

final locationServiceNotifierProvider = StateNotifierProvider<LocationServiceNotifier, dynamic>(
  (ref) => LocationServiceNotifier(ref.watch(foregroundServiceProvider)),
);

//Services
final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (ref) => LocalNotificationService(),
);

final deviceServiceProvider = Provider<DeviceService>(
  (ref) => DeviceService(),
);

final versionNotifierProvider = Provider<VersionNotifier>((ref) => VersionNotifier());

final foregroundServiceProvider = Provider<ForegroundService>(
  (ref) => ForegroundService(),
);

final sensorServiceProvider = Provider<SensorService>(
  (ref) => SensorService(ref.watch(database), ref.watch(foregroundServiceProvider)),
);

//Classifier
final stopClassifierProvider = Provider<StopClassifierNotifier>(
  (ref) => StopClassifierNotifier(
    ref.watch(sensorRepository),
    ref.watch(classifiedPeriodRepository),
  ),
);

//Databases
final database = Provider<Database>(
  (ref) => Database(),
);

//Network
final deviceApi = Provider<DeviceApi>((ref) => DeviceApi(ref.watch(database)));
final logApi = Provider<LogApi>((ref) => LogApi(ref.watch(database)));
final questionnaireApi = Provider<QuestionnaireApi>((ref) => QuestionnaireApi(ref.watch(database)));
final reasonApi = Provider<ReasonApi>((ref) => ReasonApi(ref.watch(database)));
final vehicleApi = Provider<VehicleApi>((ref) => VehicleApi(ref.watch(database)));
final authApi = Provider<AuthApi>((ref) => AuthApi(ref.watch(database)));
final googleMapsApi = Provider<GoogleMapsApi>((ref) => GoogleMapsApi(ref.watch(database)));
final errorLogApi = Provider<ErrorLogApi>((ref) => ErrorLogApi(ref.watch(database)));
final trackerApi = Provider<TrackerApi>((ref) => TrackerApi(ref.watch(database)));
final trackedApi = Provider<TrackedApi>((ref) => TrackedApi(ref.watch(database)));
final sensorGeolocationApi = Provider<SensorGeolocationApi>((ref) => SensorGeolocationApi(ref.watch(database)));
final classifiedPeriodApi = Provider<ClassifiedPeriodApi>((ref) => ClassifiedPeriodApi(ref.watch(database)));
final stopApi = Provider<StopApi>((ref) => StopApi(ref.watch(database)));
final movementApi = Provider<MovementApi>((ref) => MovementApi(ref.watch(database)));
final manualGeolocationApi = Provider<ManualGeolocationApi>((ref) => ManualGeolocationApi(ref.watch(database)));

//Repositories
final deviceRepository = Provider<DeviceRepository>(
  (ref) => DeviceRepository(ref.watch(deviceApi), ref.watch(database), ref.watch(deviceServiceProvider)),
);

final localizationRepository = Provider<LocalizationRepository>(
  (ref) => LocalizationRepository(),
);

final logRepository = Provider<LogRepository>(
  (ref) => LogRepository(ref.watch(logApi), ref.watch(database), ref.watch(deviceRepository)),
);

final errorLogRepository = Provider<ErrorLogRepository>(
  (ref) => ErrorLogRepository(ref.watch(errorLogApi)),
);

final questionnaireRepository = Provider<QuestionnaireRepository>(
  (ref) => QuestionnaireRepository(ref.watch(questionnaireApi)),
);

final trackedDayRepository = Provider<TrackedDayRepository>(
  (ref) => TrackedDayRepository(ref.watch(database), ref.watch(trackedApi)),
);

final sensorRepository = Provider<SensorRepository>(
  (ref) => SensorRepository(ref.watch(database), ref.watch(sensorGeolocationApi)),
);

final classifiedPeriodRepository = Provider<ClassifiedPeriodRepository>(
  (ref) => ClassifiedPeriodRepository(ref.watch(database), ref.watch(trackedDayRepository), ref.watch(classifiedPeriodApi), ref.watch(googleMapsRepository)),
);

final stopRepository = Provider<StopRepository>(
  (ref) => StopRepository(ref.watch(database), ref.watch(stopApi)),
);

final movementRepository = Provider<MovementRepository>(
  (ref) => MovementRepository(ref.watch(database), ref.watch(movementApi)),
);

final manualGeolocationRepository = Provider<ManualGeolocationRepository>(
  (ref) => ManualGeolocationRepository(ref.watch(database), ref.watch(manualGeolocationApi)),
);

final googleMapsRepository = Provider<GoogleMapsRepository>(
  (ref) => GoogleMapsRepository(ref.watch(database), ref.watch(googleMapsApi), ref.watch(googleMapsCacheProvider)),
);

final reasonRepository = Provider<ReasonRepository>(
  (ref) => ReasonRepository(ref.watch(database), ref.watch(reasonApi)),
);

final vehicleRepository = Provider<VehicleRepository>(
  (ref) => VehicleRepository(ref.watch(database), ref.watch(vehicleApi)),
);

//  Cache
final googleMapsCacheProvider = Provider<GoogleMapsCache>((ref) => GoogleMapsCache());
