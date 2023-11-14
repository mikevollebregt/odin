import 'package:desktop/infastructure/classifier/is_moving_classifier.dart';
import 'package:desktop/infastructure/notifiers/testcase_raw_detail_notifier.dart';
import 'package:desktop/infastructure/period_classifier/accuracy_classifier.dart';
import 'package:desktop/infastructure/repositories/network/classified_period_api.dart';
import 'package:desktop/infastructure/repositories/network/google_api.dart';
import 'package:desktop/infastructure/repositories/network/verification_api.dart';
import 'package:desktop/infastructure/services/convert_data_structure_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'infastructure/notifiers/detail_notifier.dart';
import 'infastructure/notifiers/google_detail_notifier.dart';
import 'infastructure/notifiers/location_map_notifier.dart';
import 'infastructure/notifiers/movement_notifier.dart';
import 'infastructure/notifiers/osm_bicycle_infrastructure_notifier.dart';
import 'infastructure/notifiers/osm_busline_infrastructure_notifier.dart';
import 'infastructure/notifiers/osm_car_infrastructure_notifier.dart';
import 'infastructure/notifiers/osm_subway_infrastructure_notifier.dart';
import 'infastructure/notifiers/osm_train_infrastructure_notifier.dart';
import 'infastructure/notifiers/osm_tram_infrastructure_notifier.dart';
import 'infastructure/notifiers/osm_walking_infrastructure_notifier.dart';
import 'infastructure/notifiers/testcase_detail_notifier.dart';
import 'infastructure/notifiers/testcase_list_detail_notifier.dart';
import 'infastructure/notifiers/testcase_list_notifier.dart';
import 'infastructure/notifiers/tom_algo_notifier.dart';
import 'infastructure/notifiers/train_source_notifier.dart';
import 'infastructure/notifiers/useful_days_user_notifier.dart';
import 'infastructure/notifiers/user_details_notifier.dart';
import 'infastructure/notifiers/user_list_notifier.dart';
import 'infastructure/notifiers/validated_notifier.dart';
import 'infastructure/period_classifier/density_threshold_classifier.dart';
import 'infastructure/period_classifier/poi_classifier.dart';
import 'infastructure/period_classifier/reason_classifier.dart';
import 'infastructure/period_classifier/sensor_classifier.dart';
import 'infastructure/period_classifier/vehicle_classifier.dart';
import 'infastructure/repositories/database/database.dart';
import 'infastructure/repositories/network/auth_api.dart';
import 'infastructure/repositories/network/osm_api.dart';
import 'infastructure/repositories/network/pdok_api.dart';
import 'infastructure/repositories/network/sensor_geo_location_api.dart';
import 'infastructure/repositories/network/testcase_api.dart';
import 'infastructure/repositories/network/train_source_api.dart';
import 'infastructure/repositories/network/vehicle_classifier_api.dart';

final trainSourceApi = Provider<TrainSourceApi>((ref) => TrainSourceApi(ref.watch(database)));
final pdokApi = Provider<PDOKApi>((ref) => PDOKApi(ref.watch(database)));
final googleApi = Provider<GoogleApi>((ref) => GoogleApi(ref.watch(database)));
final testcaseApi = Provider<TestCaseApi>((ref) => TestCaseApi(ref.watch(database)));
final authApi = Provider<AuthApi>((ref) => AuthApi(ref.watch(database)));
final sensorGeoLocationApi = Provider<SensorGeoLocationApi>((ref) => SensorGeoLocationApi(ref.watch(database)));
final verificationApi = Provider<VerificationApi>((ref) => VerificationApi(ref.watch(database)));
final classifiedPeriodApi = Provider<ClassifiedPeriodApi>((ref) => ClassifiedPeriodApi(ref.watch(database)));
final osmApi = Provider<OSMApi>((ref) => OSMApi(ref.watch(database)));
final vehicleClassifierApi = Provider<VehicleClassifierApi>((ref) => VehicleClassifierApi(ref.watch(database)));

//service
final convertDataStructureService =
    Provider<ConvertDataStructureService>((ref) => ConvertDataStructureService(ref.watch(testcaseApi), ref.watch(sensorGeoLocationApi)));

//repo

//notifier
final osmTrainNotifierProvider = StateNotifierProvider(
  (ref) => OSMTrainInfrastructureNotifier(ref.watch(osmApi)),
);

final osmTramNotifierProvider = StateNotifierProvider(
  (ref) => OSMTramInfrastructureNotifier(ref.watch(osmApi)),
);

final osmSubwayNotifierProvider = StateNotifierProvider(
  (ref) => OSMSubwayInfrastructureNotifier(ref.watch(osmApi)),
);

final osmCarNotifierProvider = StateNotifierProvider(
  (ref) => OSMCarInfrastructureNotifier(ref.watch(osmApi)),
);

final osmBicycleNotifierProvider = StateNotifierProvider(
  (ref) => OSMBicycleInfrastructureNotifier(ref.watch(osmApi)),
);

final osmBusNotifierProvider = StateNotifierProvider(
  (ref) => OSMBusLineInfrastructureNotifier(ref.watch(osmApi)),
);

final osmWalkingNotifierProvider = StateNotifierProvider(
  (ref) => OSMWalkingInfrastructureNotifier(ref.watch(osmApi)),
);

final trainSourceNotifierProvider = StateNotifierProvider(
  (ref) => TrainSourceNotifier(ref.watch(trainSourceApi)),
);

final googleDetailsNotifierProvider = StateNotifierProvider(
  (ref) => GoogleDetailNotifier(ref.watch(googleApi), ref.watch(pdokApi)),
);

final locationMapNotifierProvider =
    StateNotifierProvider((ref) => LocationMapNotifier(ref.watch(googleDetailsNotifierProvider.notifier), ref.watch(detailNotifierProvider)));

final validatedNotifierProvider = StateNotifierProvider(
  (ref) => ValidatedNotifier(ref.watch(classifiedPeriodApi)),
);

final userListNotifierProvider = StateNotifierProvider(
  (ref) => UserListNotifier(ref.watch(verificationApi), ref.watch(convertDataStructureService)),
);

final userDetailsNotifierProvider = StateNotifierProvider(
  (ref) => UserDetailsNotifier(ref.watch(verificationApi)),
);

final testcaseListNotifierProvider = StateNotifierProvider(
  (ref) => TestCaseListNotifier(ref.watch(testcaseApi), ref.watch(testcaseDetailNotifierProvider.notifier), ref.watch(authApi),
      ref.watch(convertDataStructureService), ref.watch(testcaseListDetailNotifierProvider.notifier)),
);

final testcaseListDetailNotifierProvider = StateNotifierProvider(
  (ref) => TestCaseListDetailNotifier(
      ref.watch(testcaseApi), ref.watch(testcaseDetailNotifierProvider.notifier), ref.watch(authApi), ref.watch(convertDataStructureService)),
);

final testcaseRawDetailNotifierProvider = StateNotifierProvider(
  (ref) => TestCaseRawDetailNotifier(),
);

final testcaseDetailNotifierProvider = StateNotifierProvider((ref) => TestCaseDetailNotifier(
    ref.watch(testcaseApi), ref.watch(testcaseRawDetailNotifierProvider.notifier), ref.watch(testcaseTomAlgoDetailNotifierProvider.notifier)));

final usefulDaysUserNotifier = StateNotifierProvider(
  (ref) => UsefulDaysUserNotifier(ref.watch(testcaseApi)),
);

final detailNotifierProvider = ChangeNotifierProvider(
  (ref) => DetailNotifier(),
);

// final testcaseAlgoDetailNotifierProvider = StateNotifierProvider(
//   (ref) => TestCaseAlgoDetailNotifier(AlgoService()),
// );

final testcaseTomAlgoDetailNotifierProvider = StateNotifierProvider(
  (ref) => TestCaseTomAlgoDetailNotifier(),
);

// final algoNotifierProvider = StateNotifierProvider(
//   (ref) =>
//       AlgoNotifier(ref.watch(database), ref.watch(isMovingClassifierProvider)),
// );

//classifiedPeriod classifier
final accuracyClassifierProvider = Provider<AccuracyClassifier>(
  (ref) => AccuracyClassifier(),
);

final sensorClassifierProvider = Provider<SensorClassifier>(
  (ref) => SensorClassifier(),
);

final vehicleClassifierProvider = Provider<VehicleClassifier>(
  (ref) => VehicleClassifier(ref.watch(vehicleClassifierApi)),
);

final reasonClassifierProvider = Provider<ReasonClassifier>(
  (ref) => ReasonClassifier(),
);

final poiClassifierProvider = Provider<POIClassifier>(
  (ref) => POIClassifier(),
);

final densityThresholdClassifierProvider = Provider<DensityThresholdClassifier>(
  (ref) => DensityThresholdClassifier(),
);

//classifier
final isMovingClassifierProvider = Provider<IsMovingClassifier>(
  (ref) => IsMovingClassifier(),
);

//service

// final algoServiceProvider = Provider<AlgoService>(
//   (ref) => AlgoService(ref.watch(database)),
// );

//Databases
final database = Provider<Database>(
  (ref) => Database(),
);
