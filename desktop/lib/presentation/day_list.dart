import 'package:desktop/infastructure/repositories/dtos/pdok_response_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/train_properties_dto.dart';
import 'package:desktop/presentation/widgets/movement_tile_widget.dart';
import 'package:desktop/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infastructure/notifiers/cluster_notifier.dart';
import '../infastructure/notifiers/density_cluster_notifier.dart';
import '../infastructure/notifiers/generic_notifier.dart';
import '../infastructure/notifiers/location_map_notifier.dart';
import '../infastructure/notifiers/movement_notifier.dart';
import '../infastructure/notifiers/useful_days_notifier.dart';
import '../infastructure/period_classifier/enums/transport_enum.dart';
import '../infastructure/repositories/dtos/location_map_dto.dart';
import '../infastructure/repositories/dtos/processed_day_dto.dart';
import '../infastructure/repositories/dtos/user_sensor_geolocation_data_dto.dart';
import 'LineChartSample2.dart';
import 'location_map.dart';
import 'dart:math';

class DayList extends ConsumerWidget {
  const DayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usefulDaysUserNotifier);
    if (state is Loaded<List<UserSensorGeolocationDataDTO>>) {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: state.loadedObject.length,
          itemBuilder: (context, i) {
            return _buildItem(context, state.loadedObject[i], ref);
          },
        ),
      );
    } else {
      return const Text("Loading..");
    }
  }

  Widget _buildItem(BuildContext context, UserSensorGeolocationDataDTO userSensorGeolocation, WidgetRef ref) {
    final usefulDaysNotifierProvider = StateNotifierProvider((ref) => UsefulDaysNotifier(ref.watch(testcaseApi)));
    final locationMapNotifierProvider =
        StateNotifierProvider((ref) => LocationMapNotifier(ref.watch(googleDetailsNotifierProvider.notifier), ref.watch(detailNotifierProvider)));
    final clusterNotifierProvider = StateNotifierProvider((ref) => ClusterNotifier(ref.watch(vehicleClassifierProvider)));
    final densityClusterNotifierProvider = StateNotifierProvider((ref) => DensityClusterNotifier(ref.watch(googleApi)));
    final movementNotifierProvider = StateNotifierProvider((ref) => MovementNotifier());

    final clusterNotifier = ref.read(clusterNotifierProvider.notifier);
    final usefulDaysNotifier = ref.read(usefulDaysNotifierProvider.notifier);
    final locationMapNotifier = ref.read(locationMapNotifierProvider.notifier);

    usefulDaysNotifier.getDaysAsync(userSensorGeolocation.userDaySensorCountViewsId);

    return SizedBox(
        child: Row(children: [
      const SizedBox(height: 200),
      Column(
        children: [
          Text(userSensorGeolocation.user),
          Text("Id: ${userSensorGeolocation.userDaySensorCountViewsId} - Count: ${userSensorGeolocation.sensorCount}"),
          Text("UsedId: ${userSensorGeolocation.userId}")
        ],
      ),
      Consumer(builder: (context, ref, child) {
        final state = ref.watch(usefulDaysNotifierProvider);

        if (state is! Loaded<ProcessedDayDTO>) {
          return const CircularProgressIndicator();
        }

        locationMapNotifier.showProcessedDayOnMapAsync(state.loadedObject);
        clusterNotifier.createClusters(state.loadedObject.normalSensorGeolocations);

        return Column(children: [
          //show the raw data from sensors on the map
          // Row(children: [
          //   _buildOSMTrainSource(),
          //   const SizedBox(width: 20),
          //   _buildOSMSubwaySource(),
          //   const SizedBox(width: 20),
          //   _buildOSMTramSource(),
          //   const SizedBox(
          //     width: 20,
          //   )
          // ]),
          // const SizedBox(height: 50),
          // Row(children: [
          //   _buildOSMBicycleSource(),
          //   const SizedBox(width: 20),
          //   _buildOSMCarSource(),
          //   const SizedBox(width: 20),
          //   _buildOSMWalkingSource(),
          //   const SizedBox(width: 20)
          // ]),

          // Row(children: [
          //   _buildOSMBusSource(),
          //   const SizedBox(width: 20),
          // ]),
          // Row(children: [
          //   //_buildLocationDetails(context),
          //   // const SizedBox(width: 20),
          //   //_buildRawMap(locationMapNotifierProvider, state.loadedObject),
          //   //_buildDetailLocation(),
          //   //_buildNormalMap(locationMapNotifier, state.loadedObject),
          //   const SizedBox(width: 20),
          //   // _buildFusedMap(locationMapNotifier, state.loadedObject),
          //   // const SizedBox(width: 20),
          //   // _buildBalancedMap(locationMapNotifier, state.loadedObject),
          // ]),
          Row(
            children: [
              _buildAccuracyMap(context, state.loadedObject, locationMapNotifier),
              _buildAccuracyChart(context, state.loadedObject, locationMapNotifier),
            ],
          ),
          //show the data from every 5 min on a chart
          Row(children: [
            // _buildGroupedNormalChart(context, state.loadedObject),
            // const SizedBox(width: 20),
            // _buildGroupedFusedChart(context, state.loadedObject),
            // const SizedBox(width: 20),
            // _buildGroupedBalancedChart(context, state.loadedObject)
          ]),
          //const SizedBox(height: 50),
          //show the data from every 5 min by amount of sensor points and batterylife
          // Row(children: [
          //   _buildGroupedSensorsChart(context, state.loadedObject),
          //   _buildGroupedBatteryChart(context, state.loadedObject),
          // ]),
          //const SizedBox(height: 50),

          //MOVEMENTS:: start classifying movements

          //show speeds - TODO:: need to migrate speed to the SQL database, currently there is no data
          Row(
            children: [
              _buildNormalCalculatedSpeedHeatMap(context, state.loadedObject, locationMapNotifier),
              _buildCalculatedSpeedNormalChart(context, state.loadedObject, locationMapNotifier),
              // _buildSpeedFusedHeatMap(context, state.loadedObject, locationMapNotifier),
              // _buildSpeedBalancedHeatMap(context, state.loadedObject, locationMapNotifier)
            ],
          ),
          // const SizedBox(height: 50),
          //show calculated speeds on map
          // Row(
          //   children: [
          //     _buildNormalCalculatedSpeedHeatMap(context, state.loadedObject, locationMapNotifier),
          //     const SizedBox(width: 20),
          //     // _buildFusedCalculatedSpeedHeatMap(context, state.loadedObject, locationMapNotifier),
          //     // const SizedBox(width: 20),
          //     // _buildBalancedCalculatedSpeedHeatMap(context, state.loadedObject, locationMapNotifier)
          //   ],
          // ),
          //show calculated speeds on chart
          // const SizedBox(height: 50),
          Row(
            children: [
              const SizedBox(width: 20),
              // _buildCalculatedSpeedFusedChart(context, state.loadedObject, locationMapNotifier),
              // const SizedBox(width: 20),
              // _buildCalculatedSpeedBalancedChart(context, state.loadedObject, locationMapNotifier)
            ],
          ),
          //show cluster median calculated speed
          // const SizedBox(height: 50),
          // Row(
          //   children: [
          //_buildMedianClusterCalculatedNormalSpeedHeatMap(context, state.loadedObject, locationMapNotifier),
          //     const SizedBox(width: 20),
          //     // _buildMedianClusterCalculatedFusedSpeedHeatMap(context, state.loadedObject, locationMapNotifier),
          //     // const SizedBox(width: 20),
          //     // _buildMedianClusterCalculatedBalancedSpeedHeatMap(context, state.loadedObject, locationMapNotifier)
          //   ],
          // ),
          //show acceleration and deceleration
          // const SizedBox(height: 50),
          // Row(
          //   children: [
          //     _buildNormalCalculatedAccelerationHeatMap(context, state.loadedObject, locationMapNotifier),
          //     const SizedBox(width: 20),
          //     // _buildFusedCalculatedAccelerationHeatMap(context, state.loadedObject, locationMapNotifier),
          //     // const SizedBox(width: 20),
          //     // _buildBalancedCalculatedAccelerationHeatMap(context, state.loadedObject, locationMapNotifier)
          //   ],
          // ),

          //show acceleration and deceleration median cluster
          // const SizedBox(height: 50),
          // Row(
          //   children: [
          //     _buildNormalCalculatedClusterAccelerationHeatMap(context, state.loadedObject, locationMapNotifier),
          //     const SizedBox(width: 20),
          //     // _buildFusedCalculatedClusterAccelerationHeatMap(context, state.loadedObject, locationMapNotifier),
          //     // const SizedBox(width: 20),
          //     // _buildBalancedCalculatedClusterAccelerationHeatMap(context, state.loadedObject, locationMapNotifier)
          //   ],
          // ),

          //show acceleration and deceleration on chart
          // const SizedBox(height: 50),
          // Row(
          //   children: [
          //     _buildCalculatedAccelerationNormalChart(context, state.loadedObject, locationMapNotifier),
          //     const SizedBox(width: 20),
          //     // _buildCalculatedAccelerationFusedChart(context, state.loadedObject, locationMapNotifier),
          //     // const SizedBox(width: 20),
          //     // _buildCalculatedAccelerationBalancedChart(context, state.loadedObject, locationMapNotifier)
          //   ],
          // ),
          //######## This is the important stuff #########
          // const SizedBox(height: 50),
          // Row(children: [
          //   _buildRawMap(locationMapNotifierProvider, state.loadedObject),
          //   const SizedBox(width: 20),
          //   _buildTrainClusterNormalMap(context, clusterNotifierProvider),
          //   const SizedBox(width: 20),
          //   _buildTramClusterNormalMap(context, clusterNotifierProvider),
          // ]),
          // Row(children: [
          //   _buildMetroClusterNormalMap(context, clusterNotifierProvider),
          //   _buildBusClusterNormalMap(context, clusterNotifierProvider),
          //   _buildVehicleRawMap(context, clusterNotifierProvider),
          // ]),
          // Row(children: [
          //   _buildAccuracyMap(context, state.loadedObject, locationMapNotifier),
          //   //_buildMovementCluster(context, clusterNotifierProvider, movementNotifierProvider),
          //   _buildMovementNormalMap(context, clusterNotifierProvider, movementNotifierProvider),
          //   _buildMovementNormalDetails(context, clusterNotifierProvider, movementNotifierProvider),
          // ]),
          Row(children: [
            //_buildMovementCluster(context, clusterNotifierProvider, movementNotifierProvider),
          ]),
          Row(
            children: [
              // _buildRandomClusterNormalMap(context, clusterNotifierProvider),
              const SizedBox(width: 20),
              // _buildClusterTrainDetails(context, clusterNotifierProvider),
              // _buildClusterDetails(context, clusterNotifierProvider),
            ],
          ),
          //###### Till here ######
          // const SizedBox(height: 50),
          // const SizedBox(height: 50),
          // //Row(children: [const SizedBox(width: 20), _buildMovementNormalMap(context, clusterNotifierProvider)]),
          // const SizedBox(height: 50),
          // Row(
          //   children: [
          //_buildVehicleNormalMap(context, clusterNotifierProvider),
          //     const SizedBox(width: 20),
          //     _buildVehicleFusedMap(context, clusterNotifierProvider),
          //     const SizedBox(width: 20),
          //     _buildVehicleBalancedMap(context, clusterNotifierProvider),
          //   ],
          // ),
          const SizedBox(height: 150),
        ]);
      }),
      const SizedBox(height: 200),
    ]));
  }

  Widget _buildDetailLocation() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(detailNotifierProvider);

      if (state.location != null) {
        return Text(DateTime.fromMillisecondsSinceEpoch(state.location!.createdOn).toString());
      } else {
        return Container();
      }
    });
  }

  Widget _buildTrainSource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(trainSourceNotifierProvider);
      final notifier = ref.watch(trainSourceNotifierProvider.notifier);

      if (state is Loaded<List<TrainPropertyDTO>>) {
        return Column(children: [const Text("TrainSource"), const SizedBox(height: 10), LocationMap(notifier.getRawLocationMapDTO(state.loadedObject))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildOSMTrainSource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(osmTrainNotifierProvider);
      final notifier = ref.watch(osmTrainNotifierProvider.notifier);

      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("TrainSource"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildOSMBusSource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(osmBusNotifierProvider);
      final notifier = ref.watch(osmBusNotifierProvider.notifier);

      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("BusSource"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildOSMTramSource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(osmTramNotifierProvider);
      final notifier = ref.watch(osmTramNotifierProvider.notifier);

      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("TramSource"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildOSMSubwaySource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(osmSubwayNotifierProvider);
      final notifier = ref.watch(osmSubwayNotifierProvider.notifier);

      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("SubwaySource"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildOSMBicycleSource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(osmBicycleNotifierProvider);
      final notifier = ref.watch(osmBicycleNotifierProvider.notifier);

      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("BicycleSource"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildOSMWalkingSource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(osmWalkingNotifierProvider);
      final notifier = ref.watch(osmWalkingNotifierProvider.notifier);

      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("WalkingSource"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildOSMCarSource() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(osmCarNotifierProvider);
      final notifier = ref.watch(osmCarNotifierProvider.notifier);

      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("CarSource"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildFusedMap(LocationMapNotifier locationMapNotifier, ProcessedDayDTO processedDay) {
    return Column(children: [
      const Text("Fused"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getRawLocationMapDTO(processedDay.fusedSensorGeolocations))
    ]);
  }

  Widget _buildBalancedMap(LocationMapNotifier locationMapNotifier, ProcessedDayDTO processedDay) {
    return Column(children: [
      const Text("Balanced"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getRawLocationMapDTO(processedDay.balancedSensorGeolocations))
    ]);
  }

  Widget _buildNormalMap(LocationMapNotifier locationMapNotifier, ProcessedDayDTO processedDay) {
    return Column(children: [
      const Text("Normal"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getNormalRawLocationMapDTO(processedDay.normalSensorGeolocations))
    ]);
  }

  Widget _buildRawMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider, ProcessedDayDTO processedDay) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<LocationMapDTO>) {
        return Column(children: [const Text("Raw normal"), const SizedBox(height: 10), LocationMap(state.loadedObject)]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildAccuracyMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Accuracy heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getAccuracyLocationMapDTO(day.normalSensorGeolocations))
    ]);
  }

  Widget _buildBatteryChart(BuildContext context, ProcessedDayDTO day) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Battery "),
            const SizedBox(height: 10),
            SimpleTimeSeriesChart.createLineCart(
                day.sensorGeolocations.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.batteryLevel.toInt())).toList()),
          ],
        ));
  }

  Widget _buildGroupedBatteryChart(BuildContext context, ProcessedDayDTO day) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Grouped Battery "),
            const SizedBox(height: 10),
            SimpleTimeSeriesChart.createLineCart(
                day.groupedBatteries.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.time), e.batteryLevel.toInt())).toList()),
          ],
        ));
  }

  Widget _buildGroupedSensorsChart(BuildContext context, ProcessedDayDTO day) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Grouped sensor per hour"),
            const SizedBox(height: 10),
            SimpleTimeSeriesChart.createLineCart(
                day.groupedRawdata.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.time), e.count.toInt())).toList()),
          ],
        ));
  }

  Widget _buildGroupedFusedChart(BuildContext context, ProcessedDayDTO day) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Grouped fused"),
            const SizedBox(height: 10),
            SimpleTimeSeriesChart.createLineCart(
                day.groupedFusedSensorLocations.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.time), e.count.toInt())).toList()),
          ],
        ));
  }

  Widget _buildGroupedNormalChart(BuildContext context, ProcessedDayDTO day) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Grouped normal"),
            const SizedBox(height: 10),
            SimpleTimeSeriesChart.createLineCart(
                day.groupedNormalSensorLocations.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.time), e.count.toInt())).toList()),
          ],
        ));
  }

  Widget _buildGroupedBalancedChart(BuildContext context, ProcessedDayDTO day) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Grouped balanced"),
            const SizedBox(height: 10),
            SimpleTimeSeriesChart.createLineCart(
                day.groupedBalancedSensorLocations.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.time), e.count.toInt())).toList()),
          ],
        ));
  }

  Widget _buildNormalCalculatedSpeedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated normal heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getCalculatedSpeedLocationMapDTO(day.normalSensorGeolocations))
    ]);
  }

  Widget _buildFusedCalculatedSpeedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated fused heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getCalculatedSpeedLocationMapDTO(day.fusedSensorGeolocations))
    ]);
  }

  Widget _buildBalancedCalculatedSpeedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated balanced heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getCalculatedSpeedLocationMapDTO(day.balancedSensorGeolocations))
    ]);
  }

  Widget _buildNormalCalculatedClusterAccelerationHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated acceleration cluster normal heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getClusterCalculatedAccelerationSpeedLocationMapDTO(day.normalSensorGeolocations))
    ]);
  }

  Widget _buildFusedCalculatedClusterAccelerationHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated acceleration cluster fused heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getClusterCalculatedAccelerationSpeedLocationMapDTO(day.fusedSensorGeolocations))
    ]);
  }

  Widget _buildBalancedCalculatedClusterAccelerationHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated acceleration cluster balanced heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getClusterCalculatedAccelerationSpeedLocationMapDTO(day.balancedSensorGeolocations))
    ]);
  }

  Widget _buildNormalCalculatedAccelerationHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated acceleration normal heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getCalculatedAccelerationSpeedLocationMapDTO(day.normalSensorGeolocations))
    ]);
  }

  Widget _buildFusedCalculatedAccelerationHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated acceleration fused heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getCalculatedAccelerationSpeedLocationMapDTO(day.fusedSensorGeolocations))
    ]);
  }

  Widget _buildBalancedCalculatedAccelerationHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Calculated acceleration balanced heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getCalculatedAccelerationSpeedLocationMapDTO(day.balancedSensorGeolocations))
    ]);
  }

  Widget _buildSpeedNormalHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Speed normal heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getSpeedLocationMapDTO(day.normalSensorGeolocations))
    ]);
  }

  Widget _buildSpeedFusedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Speed fused heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getSpeedLocationMapDTO(day.fusedSensorGeolocations))
    ]);
  }

  Widget _buildSpeedBalancedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Speed balanced heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getSpeedLocationMapDTO(day.balancedSensorGeolocations))
    ]);
  }

  Widget _buildAccuracyChart(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Accuracy chart"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(day.normalSensorGeolocations
                .map(
                    (e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.accuracy.isNaN || e.accuracy.isInfinite ? 0 : e.accuracy.toInt()))
                .toList()),
          ],
        ));
  }

  Widget _buildCalculatedSpeedNormalChart(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Calculated speed normal"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(day.normalSensorGeolocations
                .map((e) => TimeSeriesPing(
                    DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.calculatedSpeed.isNaN || e.calculatedSpeed.isInfinite ? 0 : e.calculatedSpeed.toInt()))
                .toList()),
          ],
        ));
  }

  Widget _buildCalculatedSpeedFusedChart(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Calculated speed fused"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(day.fusedSensorGeolocations
                .map((e) => TimeSeriesPing(
                    DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.calculatedSpeed.isNaN || e.calculatedSpeed.isInfinite ? 0 : e.calculatedSpeed.toInt()))
                .toList()),
          ],
        ));
  }

  Widget _buildCalculatedSpeedBalancedChart(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Calculated speed balanced"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(day.balancedSensorGeolocations
                .map((e) => TimeSeriesPing(
                    DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.calculatedSpeed.isNaN || e.calculatedSpeed.isInfinite ? 0 : e.calculatedSpeed.toInt()))
                .toList()),
          ],
        ));
  }

  Widget _buildMedianClusterCalculatedNormalSpeedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Cluster Median Calculated normal heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getClusterCalculatedSpeedLocationMapDTO(day.normalSensorGeolocations))
    ]);
  }

  Widget _buildMedianClusterCalculatedFusedSpeedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Cluster Median Calculated fused heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getClusterCalculatedSpeedLocationMapDTO(day.fusedSensorGeolocations))
    ]);
  }

  Widget _buildMedianClusterCalculatedBalancedSpeedHeatMap(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return Column(children: [
      const Text("Cluster Median Calculated balanced heatmap"),
      const SizedBox(height: 10),
      LocationMap(locationMapNotifier.getClusterCalculatedSpeedLocationMapDTO(day.balancedSensorGeolocations))
    ]);
  }

  Widget _buildCalculatedAccelerationNormalChart(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Calculated acceleration speed normal"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(day.normalSensorGeolocations
                .map((e) => TimeSeriesPing(
                    DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.acceleration.isNaN || e.acceleration.isInfinite ? 0 : e.acceleration.toInt()))
                .toList()),
          ],
        ));
  }

  Widget _buildCalculatedAccelerationFusedChart(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Calculated acceleration speed fused"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(day.fusedSensorGeolocations
                .map((e) => TimeSeriesPing(
                    DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.acceleration.isNaN || e.acceleration.isInfinite ? 0 : e.acceleration.toInt()))
                .toList()),
          ],
        ));
  }

  Widget _buildCalculatedAccelerationBalancedChart(BuildContext context, ProcessedDayDTO day, LocationMapNotifier locationMapNotifier) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("Calculated acceleration speed balanced"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(day.balancedSensorGeolocations
                .map((e) => TimeSeriesPing(
                    DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.acceleration.isNaN || e.acceleration.isInfinite ? 0 : e.acceleration.toInt()))
                .toList()),
          ],
        ));
  }

  Widget _buildRandomClusterNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Vehicle map normal"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createRandomColorMap(state.loadedObject[1], "normal"),
            ),
            const SizedBox(height: 20),
            _buildTransportCalendar()
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildTrainClusterNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Train map normal"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createTrainMap(state.loadedObject[1], "normal"),
            ),
            const SizedBox(height: 20),
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildTramClusterNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Tram map normal"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createTramMap(state.loadedObject[1], "normal"),
            ),
            const SizedBox(height: 20),
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildMetroClusterNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Metro map normal"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createSubwayMap(state.loadedObject[1], "normal"),
            ),
            const SizedBox(height: 20),
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildCarClusterNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Car map normal"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createTrainMap(state.loadedObject[1], "normal"),
            ),
            const SizedBox(height: 20),
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildBusClusterNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Bus map normal"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createBusMap(state.loadedObject[1], "normal"),
            ),
            const SizedBox(height: 20),
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildVehicleNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Vehicle map normal"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createVehicleMap(state.loadedObject[1], "normal"),
            ),
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildVehicleFusedMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Vehicle map balanced"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createVehicleMap(state.loadedObject[0], "fused"),
            ),
            const SizedBox(height: 20),
            _buildTransportCalendar()
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildClusterTrainDetails(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        List<Widget> list = state.loadedObject[1]
            .map((c) => Row(children: [
                  Container(
                    width: 30,
                    height: 30,
                    color: c.randomColor,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    color: c.classifiedVehicles.isNotEmpty &&
                            c.classifiedVehicles.firstWhere((v) => v.probableTransports.first.transport == Transport.Train).probableTransports.isNotEmpty
                        ? c.classifiedVehicles.firstWhere((v) => v.probableTransports.first.transport == Transport.Train).probableTransports.first.probability >
                                50
                            ? Colors.yellow
                            : Colors.black
                        : Colors.black,
                  ),
                  Text(
                      "StartTijd: ${c.starttime}, Endtijd: ${c.endtime}, Points: ${c.amountOfPoints}, AverageSpeed: ${c.averageSpeed}, MaxSpeed: ${c.maxSpeed}, Stations: ${c.classifiedVehicles.isNotEmpty ? c.classifiedVehicles.firstWhere((v) => v.probableTransports.first.transport == Transport.Train).trainStopsDTOs.length : 0}, TrainProbability: ${c.classifiedVehicles.isNotEmpty ? c.classifiedVehicles.first.probableTransports.first.probability : ""}"),
                ]))
            .cast<Widget>()
            .toList();
        return SizedBox(
            child: Column(
          children: list,
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildMovementDetails(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        List<Widget> list = state.loadedObject[1]
            .map((c) => Row(children: [
                  _buildColors(c),
                  Text(
                      "StartTijd: ${c.starttime}, Endtijd: ${c.endtime}, Points: ${c.amountOfPoints}, AverageSpeed: ${c.averageSpeed}, AverageAccuracy: ${c.averageAccuracy.round()}, MaxSpeed: ${c.maxSpeed}, ${_buildProbabilities(c)}}"),
                ]))
            .cast<Widget>()
            .toList();
        return SizedBox(
            child: Column(
          children: list,
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildClusterDetails(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        try {
          List<Widget> list = state.loadedObject[1]
              .map((c) => Row(children: [
                    _buildColors(c),
                    Text(
                        "StartTijd: ${c.starttime}, Endtijd: ${c.endtime}, Points: ${c.amountOfPoints}, AverageSpeed: ${c.averageSpeed}, AverageAccuracy: ${c.averageAccuracy.round()}, MaxSpeed: ${c.maxSpeed}, ${_buildProbabilities(c)}}"),
                  ]))
              .cast<Widget>()
              .toList();
          return SizedBox(
              child: Column(
            children: list,
          ));
        } catch (ex) {
          print(ex);
          return Container();
        }
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildColors(Cluster cluster) {
    var row = Row(
      children: [],
    );

    if (cluster.averageSpeed > 9) {
      var bestClassifiedVehicle = cluster.classifiedVehicles.reduce((classifiedVehicle, nextClassifiedVehicle) =>
          classifiedVehicle.probableTransports.first.probability > nextClassifiedVehicle.probableTransports.first.probability
              ? classifiedVehicle
              : nextClassifiedVehicle);

      if (bestClassifiedVehicle.probableTransports.first.probability == 0) {
        var container = Container(
          width: 30,
          height: 30,
          color: Colors.green,
        );

        return container;
      }

      var list = List<ProbableTransport>.empty(growable: true);
      var highestProbality = 0.0;

      for (var probableTransport in cluster.classifiedVehicles) {
        if (probableTransport.probableTransports.first.probability > highestProbality) {
          highestProbality = probableTransport.probableTransports.first.probability;
          list.clear();
          list.add(probableTransport.probableTransports.first);
          continue;
        }

        if (probableTransport.probableTransports.first.probability == highestProbality) {
          list.add(probableTransport.probableTransports.first);
        }
      }

      for (var item in list) {
        if (item.transport == Transport.Tram) {
          var container = Container(
            width: 30,
            height: 30,
            color: Colors.orange,
          );

          row.children.add(container);
        } else if (item.transport == Transport.Train) {
          var container = Container(
            width: 30,
            height: 30,
            color: Colors.yellow,
          );

          row.children.add(container);
        } else if (item.transport == Transport.Subway) {
          var container = Container(
            width: 30,
            height: 30,
            color: Colors.purple,
          );

          row.children.add(container);
        } else if (item.transport == Transport.Bus) {
          var container = Container(
            width: 30,
            height: 30,
            color: Colors.blue,
          );

          row.children.add(container);
        }
      }
    }

    return row;
  }

  String _buildProbabilities(Cluster cluster) {
    String probs = "";

    if (cluster.classifiedVehicles.isEmpty) {
      return probs;
    }

    for (var vehicles in cluster.classifiedVehicles) {
      if (vehicles.probableTransports.isEmpty) {
        continue;
      }

      probs += ", ${vehicles.probableTransports.first.transport.name}: ${vehicles.probableTransports.first.probability}";
    }

    return probs;
  }

  Widget _buildClusterExtraDetails(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        List<Widget> list = state.loadedObject[1]
            .map((c) => Row(children: [
                  Container(
                    width: 30,
                    height: 30,
                    color: c.randomColor,
                  ),
                  const Text(""),
                ]))
            .cast<Widget>()
            .toList();
        return SizedBox(
            child: Column(
          children: list,
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildLocationDetails(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(googleDetailsNotifierProvider);
      final notifier = ref.watch(googleDetailsNotifierProvider.notifier);

      if (state is Loaded<PDOKResponseDTO>) {
        List<Widget> list = state.loadedObject.locations.map((e) => Text(e.type)).cast<Widget>().toList();
        return SizedBox(
            child: Column(
          children: [const Text("Locations details"), const SizedBox(height: 50), Column(children: list)],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildMovementNormalDetails(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider,
      StateNotifierProvider<MovementNotifier, Object?> movementNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.read(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            height: 600,
            width: 400,
            child: Expanded(
              child: _buildClassifiedWidgets(notifier.buildMovementFromCluster(state.loadedObject[1])),
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildMovementNormalMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider,
      StateNotifierProvider<MovementNotifier, Object?> movementNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.read(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            LocationMap(
              notifier.createMovementVehicleMap(notifier.buildMovementFromCluster(state.loadedObject[1])),
            ),
            _buildMovementCalendar()
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildClassifiedWidgets(List<ClassifiedBase> periods) {
    List<Widget> widgets = List<Widget>.empty(growable: true);

    for (var period in periods) {
      widgets.add(_buildClassifiedWidget(period));
    }

    return ListView(shrinkWrap: true, children: widgets);
  }

  Widget _buildClassifiedWidget(ClassifiedBase period) {
    if (period is ClassifiedMovement) {
      return Expanded(child: MovementTile(period));
    } else if (period is ClassifiedStop) {
      return Text("StartTijd: ${period.startDate}, Endtijd: ${period.endDate}, Name: ${period.name}");
    }

    return Container();
  }

  Widget _buildVehicleRawMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Vehicle map raw"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createVehicleMap(state.loadedObject[1], "raw"),
            ),
            const SizedBox(height: 20),
            _buildTransportCalendar()
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildVehicleBalancedMap(BuildContext context, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Vehicle map balanced"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createVehicleMap(state.loadedObject[2], "balanced"),
            ),
            const SizedBox(height: 20),
            _buildTransportCalendar()
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildTransportCalendar() {
    return Column(children: [
      Row(
        children: [
          const Text("Tram"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.orange,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Train"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.yellow,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Metro"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.purple,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Bus"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.blue,
          )
        ],
      ),
      Row(
        children: [
          const Text("Unknown vehicle"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.green,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Not classified"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.red,
          )
        ],
      )
    ]);
  }

  Widget _buildMovementCalendar() {
    return Column(children: [
      Row(
        children: [
          const Text("Tram"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.orange,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Train"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.yellow,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Metro"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.purple,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Bus"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.blue,
          )
        ],
      ),
      Row(
        children: [
          const Text("Walking"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.green,
          )
        ],
      ),
      const SizedBox(height: 5),
    ]);
  }

  // Widget _buildDensityMap(
  //     BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
  //   return Consumer(builder: (context, ref, child) {
  //     final state = ref.watch(locationMapNotifierProvider);
  //     final notifier = ref.watch(locationMapNotifierProvider.notifier);

  //     if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
  //       return SizedBox(
  //           //width: MediaQuery.of(context).size.width * 0.1,
  //           //   height: MediaQuery.of(context).size.height * 0.3,
  //           child: Column(
  //         children: [
  //           const Text("density map"),
  //           const SizedBox(height: 50),
  //           LocationMap(notifier.getLocationDensityMap(notifier.getBestSensor(state.loadedObject.testRawdata)))
  //         ],
  //       ));
  //     } else {
  //       return const CircularProgressIndicator();
  //     }
  //   });
  // }

  Widget _buildDensityClusterMap(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<DensityClusterNotifier, Object?> densityClusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(densityClusterNotifierProvider);
      final notifier = ref.watch(densityClusterNotifierProvider.notifier);

      if (state is Loaded<List<List<DensityCluster>>>) {
        return SizedBox(
            //width: MediaQuery.of(context).size.width * 0.1,
            //   height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
          children: [const Text("cluster density map"), const SizedBox(height: 50), LocationMap(notifier.getLocationMap(state.loadedObject))],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildDensityCluster(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<DensityClusterNotifier, Object?> densityClusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(densityClusterNotifierProvider);
      if (state is Loaded<List<List<DensityCluster>>>) {
        return SizedBox(
            //width: MediaQuery.of(context).size.width * 0.1,
            //   height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
          children: [const Text("cluster density"), const SizedBox(height: 50), Column(children: generateDensityClusters(state.loadedObject))],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  List<Widget> generateDensityClusters(List<List<DensityCluster>> groupedClusters) {
    var widgets = <Widget>[];
    for (var clusters in groupedClusters) {
      widgets.add(Container(
        child: Text("Group, Place: ${clusters[0].place}, LatLon: ${clusters[0].location.lat}/${clusters[0].location.lon}"),
        margin: const EdgeInsets.only(top: 25),
      ));
      for (var element in clusters[0].pointsOfInterest) {
        widgets.add(Row(children: [
          //  "DistanceFromPreviousPoints: ${element.distanceFromPreviousPoint},
          Text("PointsOfInterest: $element")
        ]));
      }
    }

    return widgets;
  }
}
