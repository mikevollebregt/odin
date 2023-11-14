import '../../notifiers/cluster_notifier.dart';
import '../database/database.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class VehicleClassifierApi extends BaseApi {
  VehicleClassifierApi(Database database) : super("vehicleClassifier/", database);

  Future<ParsedResponse<ClassifiedVehicleClusterDTO>> classifyTrainCluster(Cluster cluster) async =>
      getParsedResponse<ClassifiedVehicleClusterDTO, ClassifiedVehicleClusterDTO>('ClassifyTrainCluster', ClassifiedVehicleClusterDTO.fromMap,
          payload: cluster.toJson());

  Future<ParsedResponse<ClassifiedVehicleClusterDTO>> classifyWalkingCluster(Cluster cluster) async =>
      getParsedResponse<ClassifiedVehicleClusterDTO, ClassifiedVehicleClusterDTO>('ClassifyWalkingCluster', ClassifiedVehicleClusterDTO.fromMap,
          payload: cluster.toJson());

  Future<ParsedResponse<ClassifiedVehicleClusterDTO>> classifyBicycleCluster(Cluster cluster) async =>
      getParsedResponse<ClassifiedVehicleClusterDTO, ClassifiedVehicleClusterDTO>('ClassifyBicycleCluster', ClassifiedVehicleClusterDTO.fromMap,
          payload: cluster.toJson());

  Future<ParsedResponse<ClassifiedVehicleClusterDTO>> classifyTramCluster(Cluster cluster) async =>
      getParsedResponse<ClassifiedVehicleClusterDTO, ClassifiedVehicleClusterDTO>('ClassifyTramCluster', ClassifiedVehicleClusterDTO.fromMap,
          payload: cluster.toJson());

  Future<ParsedResponse<ClassifiedVehicleClusterDTO>> classifyMetroCluster(Cluster cluster) async =>
      getParsedResponse<ClassifiedVehicleClusterDTO, ClassifiedVehicleClusterDTO>('ClassifyMetroCluster', ClassifiedVehicleClusterDTO.fromMap,
          payload: cluster.toJson());

  Future<ParsedResponse<ClassifiedVehicleClusterDTO>> classifyBusCluster(Cluster cluster) async =>
      getParsedResponse<ClassifiedVehicleClusterDTO, ClassifiedVehicleClusterDTO>('ClassifyBusCluster', ClassifiedVehicleClusterDTO.fromMap,
          payload: cluster.toJson());

  Future<ParsedResponse<ClassifiedVehicleClusterDTO>> classifyCarCluster(Cluster cluster) async =>
      getParsedResponse<ClassifiedVehicleClusterDTO, ClassifiedVehicleClusterDTO>('ClassifyCarCluster', ClassifiedVehicleClusterDTO.fromMap,
          payload: cluster.toJson());
}
