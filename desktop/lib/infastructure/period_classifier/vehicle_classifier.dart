import 'package:desktop/infastructure/repositories/dtos/vehicle_dto.dart';

import '../notifiers/cluster_notifier.dart';
import '../repositories/network/vehicle_classifier_api.dart';
import 'enums/transport_enum.dart';

class VehicleClassifier {
  final VehicleClassifierApi _vehicleClassifierApi;

  VehicleClassifier(this._vehicleClassifierApi);

  Future<List<ClassifiedVehicleClusterDTO>> getClassifierFromServer(Cluster cluster) async {
    var list = List<ClassifiedVehicleClusterDTO>.from([], growable: true);

    await Future.wait([
      _vehicleClassifierApi.classifyTrainCluster(cluster),
      _vehicleClassifierApi.classifyMetroCluster(cluster),
      _vehicleClassifierApi.classifyTramCluster(cluster),
      //_vehicleClassifierApi.classifyBicycleCluster(cluster),
      _vehicleClassifierApi.classifyBusCluster(cluster),
      //_vehicleClassifierApi.classifyCarCluster(cluster),
      //_vehicleClassifierApi.classifyWalkingCluster(cluster),
    ]).then((value) => {list.addAll(value.map((e) => e.payload!))});

    return list;
  }

  VehicleDTO getPossibleVehicle(Cluster cluster) {
    if (cluster.transport == Transport.Walking) {
      return VehicleDTO(key: "Walking");
    }

    return VehicleDTO(key: "Unknown");
  }

  Transport getProbableTransport(int averageSpeed, String sensor) {
    final probableTransport = calculateProbableTransport(averageSpeed, sensor);

    return probableTransport;
  }

  int getWalkingThreshold(String sensor) {
    switch (sensor) {
      case "normal":
        return 10;
      case "fused":
        return 15;
      case "balanced":
        return 25;
    }

    return 0;
  }

  Transport calculateProbableTransport(int averageSpeed, String sensor) {
    final walkingThreshold = getWalkingThreshold(sensor);
    if (averageSpeed < walkingThreshold) {
      return Transport.Walking;
    }

    return Transport.Unknown;
  }

  List<ProbableTransport> calculateProbableTransports(int maxSpeed, int averageSpeed) {
    if (maxSpeed > 50 && averageSpeed < 60 && averageSpeed > 10) {
      return createProbability(car: 80, tram: 20, walking: 0, bicycle: 0, unknown: 0);
    }

    if (maxSpeed > 50) {
      return createProbability(car: 20, tram: 80, walking: 0, bicycle: 0, unknown: 0);
    }

    if (maxSpeed < 30 && averageSpeed > 10) {
      return createProbability(car: 0, tram: 0, walking: 0, bicycle: 100, unknown: 0);
    }

    if (maxSpeed < 5) {
      return createProbability(car: 0, tram: 0, walking: 100, bicycle: 0, unknown: 0);
    }

    return createProbability(car: 0, tram: 0, walking: 0, bicycle: 0, unknown: 100);
  }

  List<ProbableTransport> createProbability(
      {required double car, required double tram, required double walking, required double bicycle, required double unknown}) {
    return <ProbableTransport>[
      ProbableTransport(transport: Transport.Car, probability: car),
      ProbableTransport(transport: Transport.Tram, probability: tram),
      ProbableTransport(transport: Transport.Walking, probability: walking),
      ProbableTransport(transport: Transport.Bicycle, probability: bicycle),
      ProbableTransport(transport: Transport.Unknown, probability: unknown),
    ];
  }
}
