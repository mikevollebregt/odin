import 'package:desktop/infastructure/notifiers/generic_notifier.dart';
import 'package:desktop/infastructure/repositories/dtos/classified_period_dto.dart';
import 'package:desktop/presentation/calendar/CalendarWidget.dart';
import 'package:desktop/presentation/location_map.dart';
import 'package:desktop/presentation/widgets/movement_tile_widget.dart';
import 'package:desktop/presentation/widgets/stop_tile_widget.dart';
import 'package:desktop/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../infastructure/notifiers/classifier_notifier.dart';
import '../infastructure/notifiers/cluster_notifier.dart';
import '../infastructure/notifiers/density_cluster_notifier.dart';
import '../infastructure/notifiers/location_map_notifier.dart';
import '../infastructure/repositories/dtos/location_map_dto.dart';
import '../infastructure/repositories/dtos/movement_dto.dart';
import '../infastructure/repositories/dtos/stop_dto.dart';
import '../infastructure/repositories/dtos/tracked_day_dto.dart';
import '../infastructure/repositories/dtos/user_sensor_geolocation_data_dto.dart';
import '../infastructure/repositories/dtos/user_sensor_geolocation_day_data_dto.dart';
import 'LineChartSample2.dart';

class TestCaseList extends ConsumerWidget {
  const TestCaseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testcaseListNotifierProvider);
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

  Widget _buildItem(BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, WidgetRef ref) {
    // if (testCaseDTO.user != "sensor_samsung" && testCaseDTO.user != "sensor_poco" && testCaseDTO.user != "sensor_nokia") {
    //   return Container();
    // }

    final classifierNotifierProvider = StateNotifierProvider((ref) => ClassifierNotifier(
        ref.watch(sensorClassifierProvider),
        ref.watch(accuracyClassifierProvider),
        ref.watch(vehicleClassifierProvider),
        ref.watch(reasonClassifierProvider),
        ref.watch(googleApi),
        ref.watch(poiClassifierProvider),
        ref.watch(densityThresholdClassifierProvider)));
    final locationMapNotifierProvider =
        StateNotifierProvider((ref) => LocationMapNotifier(ref.watch(googleDetailsNotifierProvider.notifier), ref.watch(detailNotifierProvider)));
    final clusterNotifierProvider = StateNotifierProvider((ref) => ClusterNotifier(ref.watch(vehicleClassifierProvider)));
    final densityClusterNotifierProvider = StateNotifierProvider((ref) => DensityClusterNotifier(ref.watch(googleApi)));

    final classifierNotifier = ref.read(classifierNotifierProvider.notifier);
    final locationMapNotifier = ref.read(locationMapNotifierProvider.notifier);
    final clusterNotifier = ref.read(clusterNotifierProvider.notifier);
    final densityClusterNotifier = ref.read(densityClusterNotifierProvider.notifier);
    const index = 1;
    //testCaseDTO.userTestDaysDataDTO.indexWhere((element) => DateTime.fromMillisecondsSinceEpoch(element.trackedDay.day).day == 8);

    if (index == -1) {
      return Container();
    }

    return Column(children: [
      Row(children: [
        InkWell(
            child: _buildPhoneData(context, testCaseDTO),
            onTap: () {
              final notifier = ref.watch(testcaseListDetailNotifierProvider.notifier);
              notifier.getDetail(testCaseDTO.userId);
            }),
        Consumer(builder: (context, ref, child) {
          final state = ref.watch(testcaseListDetailNotifierProvider);

          if (state is! Loaded<UserSensorGeolocationDataDTO>) {
            return Container();
          }

          if (testCaseDTO.userId != state.loadedObject.userId) {
            return Container();
          }

          testCaseDTO.userTestDaysDataDTO = state.loadedObject.userTestDaysDataDTO;
          locationMapNotifier.showOnMapAsync(testCaseDTO.userTestDaysDataDTO![index]);

          clusterNotifier.createClusters(testCaseDTO.userTestDaysDataDTO![index].testRawdata[0]);
          densityClusterNotifier.createClusters(testCaseDTO.userTestDaysDataDTO![index].testRawdata);
          classifierNotifier.classifyAllSensors(testCaseDTO.userTestDaysDataDTO![index].testRawdata);

          return Column(children: [
            //Row(children: [_buildSensorData(context, testCaseDTO)]),
            Row(
              children: [
                const SizedBox(width: 20),
                _buildCalendar(context, ref, testCaseDTO, locationMapNotifierProvider, clusterNotifierProvider, densityClusterNotifierProvider),
                //const SizedBox(width: 20),
                _buildRawMap(locationMapNotifierProvider),
                const SizedBox(width: 20),
                _buildSpeedNormalHeatMap(locationMapNotifierProvider),
                // const SizedBox(width: 20),
                //_buildRawFusedMap(locationMapNotifierProvider),
                const SizedBox(width: 20),
                // _buildSpeedFusedHeatMap(locationMapNotifierProvider),
                // const SizedBox(width: 20),
                _buildRawBalancedMap(locationMapNotifierProvider),
                // const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            Row(children: [
              _buildAccuracyNormalChart(context, testCaseDTO, locationMapNotifierProvider),
              //const SizedBox(width: 20),
              _buildSpeedNormalChart(context, testCaseDTO, locationMapNotifierProvider),
              const SizedBox(width: 20),
              _buildAccuracyFusedChart(context, testCaseDTO, locationMapNotifierProvider),
              //const SizedBox(width: 20),
              //_buildSpeedFusedChart(context, testCaseDTO, locationMapNotifierProvider),
              const SizedBox(width: 20),
              _buildAccuracyBalancedChart(context, testCaseDTO, locationMapNotifierProvider),
              const SizedBox(width: 20),

              const SizedBox(width: 20),
              // _buildDensityBalancedChart(context, testCaseDTO, locationMapNotifierProvider),
              // const SizedBox(width: 20),
              // _buildDensityNormalChart(context, testCaseDTO, locationMapNotifierProvider),
              // const SizedBox(width: 20),
              // _buildDensityFusedChart(context, testCaseDTO, locationMapNotifierProvider),
              //const SizedBox(width: 20),
              //_buildSpeedBalancedChart(context, testCaseDTO, locationMapNotifierProvider),
            ]),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildBatteryChart(context, testCaseDTO, locationMapNotifierProvider),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildGroupedSensorsChart(context, testCaseDTO, locationMapNotifierProvider),
                const SizedBox(width: 20),
              ],
            ),
            Row(children: [
              const SizedBox(width: 20),
              _buildCalculatedSpeedNormalChart(context, testCaseDTO, locationMapNotifierProvider),
              //   const SizedBox(width: 20),
              _buildNormalCalculatedSpeedHeatMap(locationMapNotifierProvider),
              const SizedBox(width: 20),
              _buildCalculatedSpeedFusedChart(context, testCaseDTO, locationMapNotifierProvider),
              const SizedBox(width: 20),
              _buildFusedCalculatedSpeedHeatMap(locationMapNotifierProvider),
              const SizedBox(width: 20),
              _buildCalculatedSpeedBalancedChart(context, testCaseDTO, locationMapNotifierProvider),
            ]),
            const Row(
              children: [],
            ),
            const SizedBox(height: 20),
            Row(children: [
              const SizedBox(width: 20),
              _buildDensityMap(context, testCaseDTO, locationMapNotifierProvider),
              const SizedBox(width: 20),
              _buildDensityClusterMap(context, testCaseDTO, densityClusterNotifierProvider),
              const SizedBox(width: 20),
              //_buildDensityCluster(context, testCaseDTO, densityClusterNotifierProvider),
            ]),
            Row(
              children: [
                // const SizedBox(width: 500),
                _buildClusterCalculatedSpeedHeatMap(locationMapNotifierProvider),
                const SizedBox(width: 20),
                _buildSpeedNormalClusterMap(context, testCaseDTO, clusterNotifierProvider),
                const SizedBox(width: 20),
                // _buildSpeedNormalCluster(context, testCaseDTO, clusterNotifierProvider)
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 20),
                _builNormalClassifiedPeriodMap(classifierNotifierProvider),
                const SizedBox(width: 20),
                _builFusedClassifiedPeriodMap(classifierNotifierProvider),
                const SizedBox(width: 20),
                _builBalancedClassifiedPeriodMap(classifierNotifierProvider),
              ],
            ),
            Row(
              children: [
                _buildVehicleMap(context, testCaseDTO, clusterNotifierProvider),
                const SizedBox(width: 20),
                _buildAccuracyMap(context, testCaseDTO, locationMapNotifierProvider)
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [const SizedBox(width: 20), _builClassifiedPeriod(classifierNotifierProvider)],
            ),
          ]);
        }),
      ]),
    ]);
  }

  _fromMilliseconds(int milliseconds) {
    return DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }

  // List<TimeSeriesPing> generateTimeSeries(List<UserSensorGeolocationDayDataDTO> data) {
  //   data.sort((a, b) => a.trackedDay.day.compareTo(b.trackedDay.day));
  //   var timeSeries = data.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.trackedDay.day), e.pings.length)).toList();

  //   return timeSeries;
  // }

  List<TimeSeriesPing> generateBatteryTimeSeries(List<UserSensorGeolocationDayDataDTO> data) {
    data.sort((a, b) => a.trackedDay.day.compareTo(b.trackedDay.day));
    var timeSeries = data.expand((day) => day.rawdata.map((p) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(p.createdOn), p.batteryLevel))).toList();

    return timeSeries;
  }

  Widget _builClassifiedPeriod(StateNotifierProvider<ClassifierNotifier, Object?> classifierNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(classifierNotifierProvider.notifier);
      final state = ref.watch(classifierNotifierProvider);
      if (state is Loaded<List<ClassifiedPeriodDto>>) {
        var dtos = state.loadedObject;
        return SizedBox(
            width: 400, // fixed height
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: dtos.length,
              itemBuilder: (context, index) {
                final dto = dtos[index];
                if (dto is StopDto) return StopTile(dto);
                if (dto is MovementDto) return Container(); //MovementTile(dto);
                return const SizedBox();
              },
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _builNormalClassifiedPeriodMap(StateNotifierProvider<ClassifierNotifier, Object?> classifierNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(classifierNotifierProvider.notifier);
      final state = ref.watch(classifierNotifierProvider);
      if (state is Loaded<List<List<ClassifiedPeriodDto>>>) {
        var dtos = state.loadedObject;
        return Column(
            children: [const Text("Normal Classified Map"), const SizedBox(height: 10), LocationMap(notifier.getClassifiedMapDTO(state.loadedObject[1]))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _builFusedClassifiedPeriodMap(StateNotifierProvider<ClassifierNotifier, Object?> classifierNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(classifierNotifierProvider.notifier);
      final state = ref.watch(classifierNotifierProvider);
      if (state is Loaded<List<List<ClassifiedPeriodDto>>>) {
        var dtos = state.loadedObject;
        return Column(
            children: [const Text("Fused Classified Map"), const SizedBox(height: 10), LocationMap(notifier.getClassifiedMapDTO(state.loadedObject[0]))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _builBalancedClassifiedPeriodMap(StateNotifierProvider<ClassifierNotifier, Object?> classifierNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(classifierNotifierProvider.notifier);
      final state = ref.watch(classifierNotifierProvider);
      if (state is Loaded<List<List<ClassifiedPeriodDto>>>) {
        var dtos = state.loadedObject;
        return Column(
            children: [const Text("Balanced Classified Map"), const SizedBox(height: 10), LocationMap(notifier.getClassifiedMapDTO(state.loadedObject[2]))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _builClassifiedPeriodMap(StateNotifierProvider<ClassifierNotifier, Object?> classifierNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(classifierNotifierProvider.notifier);
      final state = ref.watch(classifierNotifierProvider);
      if (state is Loaded<List<ClassifiedPeriodDto>>) {
        var dtos = state.loadedObject;
        return Column(children: [const Text("Classified Map"), const SizedBox(height: 10), LocationMap(notifier.getClassifiedMapDTO(state.loadedObject))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildRawMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(
            children: [const Text("Raw normal"), const SizedBox(height: 10), LocationMap(notifier.getRawLocationMapDTO(state.loadedObject.testRawdata[1]))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSensorCalculatedSpeedHeatMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("Cluster Median Calculated heatmap"),
          const SizedBox(height: 10),
          LocationMap(notifier.getClusterCalculatedSpeedLocationMapDTO(notifier.getBestSensor(state.loadedObject.testRawdata)))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildClusterCalculatedSpeedHeatMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("Cluster Median Calculated heatmap"),
          const SizedBox(height: 10),
          LocationMap(notifier.getClusterCalculatedSpeedLocationMapDTO(state.loadedObject.testRawdata[1]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildFusedCalculatedSpeedHeatMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("Calculated fused heatmap"),
          const SizedBox(height: 10),
          LocationMap(notifier.getCalculatedSpeedLocationMapDTO(state.loadedObject.testRawdata[0]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSensorDensityClusterMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("Density Cluster map"),
          const SizedBox(height: 10),
          LocationMap(notifier.getDensityMapDTO(notifier.getBestSensor(state.loadedObject.testRawdata)))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildNormalCalculatedSpeedHeatMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("Calculated normal heatmap"),
          const SizedBox(height: 10),
          LocationMap(notifier.getCalculatedSpeedLocationMapDTO(state.loadedObject.testRawdata[1]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedNormalHeatMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("speed heatmap"),
          const SizedBox(height: 10),
          LocationMap(notifier.getSpeedLocationMapDTO(state.loadedObject.testRawdata[1]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedFusedHeatMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("speed heatmap"),
          const SizedBox(height: 10),
          LocationMap(notifier.getSpeedLocationMapDTO(state.loadedObject.testRawdata[0]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedBalancedHeatMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("speed heatmap"),
          const SizedBox(height: 10),
          LocationMap(notifier.getSpeedLocationMapDTO(state.loadedObject.testRawdata[2]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildFusedMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("Fused"),
          const SizedBox(height: 10),
          LocationMap(notifier.getCalculatedSpeedLocationMapDTO(state.loadedObject.testRawdata[0]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildRawFusedMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(
            children: [const Text("Raw Fused"), const SizedBox(height: 10), LocationMap(notifier.getRawLocationMapDTO(state.loadedObject.testRawdata[0]))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildBalancedMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(children: [
          const Text("Balanced"),
          const SizedBox(height: 10),
          LocationMap(notifier.getCalculatedSpeedLocationMapDTO(state.loadedObject.testRawdata[2]))
        ]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildRawBalancedMap(StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return Column(
            children: [const Text("Raw Balanced"), const SizedBox(height: 10), LocationMap(notifier.getRawLocationMapDTO(state.loadedObject.testRawdata[2]))]);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildAlgoMap() {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(testcaseTomAlgoDetailNotifierProvider);
      if (state is Loaded<LocationMapDTO>) {
        return LocationMap(state.loadedObject);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildAccuracyFusedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Accuracy fused"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(state.loadedObject.testRawdata[0]
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.accuracy.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildBatteryChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Battery "),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(state.loadedObject.testRawdata[1]
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.batteryLevel.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildGroupedSensorsChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Grouped sensor per hour"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(
                    state.loadedObject.groupedRawdata.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.time), e.count.toInt())).toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildAccuracyNormalChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Accuracy normal"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(state.loadedObject.testRawdata[1]
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.accuracy.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildAccuracyBalancedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Accuracy balanced"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(state.loadedObject.testRawdata[2]
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.accuracy.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildDensityBalancedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Density balanced"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(
                    state.loadedObject.testRawdata[2].map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.density.toInt())).toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildDensityFusedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Density fused"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(
                    state.loadedObject.testRawdata[0].map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.density.toInt())).toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildDensityNormalChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Density normal"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(
                    state.loadedObject.testRawdata[1].map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.density.toInt())).toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildCalculatedSpeedFusedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Calulated Speed fused"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(state.loadedObject.testRawdata[0]
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn),
                        e.calculatedSpeed.isNaN | e.calculatedSpeed.isInfinite ? 0 : e.calculatedSpeed.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedFusedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Speed fused"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(
                    state.loadedObject.testRawdata[0].map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.speed.toInt())).toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildCalculatedSpeedNormalChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Calculated Speed normal"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(state.loadedObject.testRawdata[1]
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.calculatedSpeed.isNaN ? 0 : e.calculatedSpeed.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedNormalChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Speed normal"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(
                    state.loadedObject.testRawdata[1].map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.speed.toInt())).toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedBalancedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Speed balanced"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(
                    state.loadedObject.testRawdata[2].map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.speed.toInt())).toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildCalculatedSpeedBalancedChart(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(locationMapNotifierProvider.notifier);
      final state = ref.watch(locationMapNotifierProvider);
      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                const Text("Speed balanced"),
                const SizedBox(height: 50),
                SimpleTimeSeriesChart.createLineCart(state.loadedObject.testRawdata[2]
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn),
                        e.calculatedSpeed.isNaN || e.calculatedSpeed.isInfinite ? 0 : e.calculatedSpeed.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedBalancedCluster(
      BuildContext context, UserSensorGeolocationDayDataDTO testCaseDTO, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [const Text("cluster balanced"), const SizedBox(height: 50), Column(children: generateClusters(state.loadedObject[2]))],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedFusedCluster(
      BuildContext context, UserSensorGeolocationDayDataDTO testCaseDTO, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [const Text("cluster fused"), const SizedBox(height: 50), Column(children: generateClusters(state.loadedObject[0]))],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildDensityMap(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(locationMapNotifierProvider);
      final notifier = ref.watch(locationMapNotifierProvider.notifier);

      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            //width: MediaQuery.of(context).size.width * 0.1,
            //   height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
          children: [
            const Text("density map"),
            const SizedBox(height: 50),
            LocationMap(notifier.getLocationDensityMap(notifier.getBestSensor(state.loadedObject.testRawdata)))
          ],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

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

  Widget _buildSpeedNormalCluster(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            //width: MediaQuery.of(context).size.width * 0.1,
            //   height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
          children: [const Text("cluster normal"), const SizedBox(height: 50), Column(children: generateClusters(state.loadedObject[1]))],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSpeedNormalClusterMap(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            //width: MediaQuery.of(context).size.width * 0.1,
            //   height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
          children: [const Text("cluster normal"), const SizedBox(height: 50), LocationMap(notifier.createLocationMap(state.loadedObject[1]))],
        ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildSensorData(BuildContext context, UserSensorGeolocationDataDTO testCaseDTO) {
    var index = 1;
    return SizedBox(
        child: Column(
      children: [
        Text("sensordata " + testCaseDTO.user),
        const SizedBox(height: 50),
        testCaseDTO.userTestDaysDataDTO![index].rawdata.isNotEmpty
            ? Row(
                children: [
                  Column(children: [
                    const Text("battery used"),
                    const SizedBox(height: 20),
                    Text("Start: " +
                        testCaseDTO.userTestDaysDataDTO![index].rawdata.first.batteryLevel.toString() +
                        ", End: " +
                        testCaseDTO.userTestDaysDataDTO![index].rawdata.last.batteryLevel.toString())
                  ]),
                  const SizedBox(width: 50),
                  Column(children: [
                    const Text("fused"),
                    const SizedBox(height: 20),
                    Text(testCaseDTO.userTestDaysDataDTO![index].testRawdata[0].length.toString())
                  ]),
                  const SizedBox(width: 50),
                  Column(children: [
                    const Text("balanced"),
                    const SizedBox(height: 20),
                    Text(testCaseDTO.userTestDaysDataDTO![index].testRawdata[2].length.toString())
                  ]),
                  const SizedBox(width: 50),
                  Column(children: [
                    const Text("normal"),
                    const SizedBox(height: 20),
                    Text(testCaseDTO.userTestDaysDataDTO![index].testRawdata[1].length.toString())
                  ])
                ],
              )
            : Container()
      ],
    ));
  }

  Widget _buildVehicleMap(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(clusterNotifierProvider);
      final notifier = ref.watch(clusterNotifierProvider.notifier);

      if (state is Loaded<List<List<Cluster>>>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("vehicle map"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.createVehicleMap(state.loadedObject[1], "normal"),
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

  Widget _buildAccuracyMap(
      BuildContext context, UserSensorGeolocationDataDTO testCaseDTO, StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(locationMapNotifierProvider);
      final notifier = ref.watch(locationMapNotifierProvider.notifier);

      if (state is Loaded<UserSensorGeolocationDayDataDTO>) {
        return SizedBox(
            child: Column(
          children: [
            const Text("Accuracy map"),
            const SizedBox(height: 50),
            LocationMap(
              notifier.getAccuracyLocationMapDTO(state.loadedObject.testRawdata[1]),
            ),
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
          const Text("Car"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.blue,
          )
        ],
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Tram"),
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
          const Text("Bicycle"),
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
          const Text("Walking"),
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
          const Text("Unknown"),
          const SizedBox(width: 20),
          Container(
            width: 30,
            height: 30,
            color: Colors.black,
          )
        ],
      )
    ]);
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

  List<Widget> generateClusters(List<Cluster> clusters) {
    var widgets = <Widget>[];
    for (var element in clusters) {
      widgets.add(Text(
          "AverageSpeed: ${element.averageSpeed}, AmountOfPoints: ${element.amountOfPoints}, amountOfTime: ${element.amountOfTime}, maxSpeed: ${element.maxSpeed}, ${element.probableTransports[0].transport}: %${element.probableTransports[0].probability}, ${element.probableTransports[1].transport}: %${element.probableTransports[1].probability}, ${element.probableTransports[2].transport}: %${element.probableTransports[2].probability}, ${element.probableTransports[3].transport}: %${element.probableTransports[3].probability} "));
    }

    return widgets;
  }

  Widget _buildSensorDataChart(BuildContext context, UserSensorGeolocationDataDTO testCaseDTO) {
    final widget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("SensorData"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(
                testCaseDTO.userTestDaysDataDTO!.map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.trackedDay.day), e.rawdata.length)).toList()),
          ],
        ));

    return widget;
  }

  Widget _buildBatteryLevelChart(BuildContext context, UserSensorGeolocationDataDTO testCaseDTO) {
    final widget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            const Text("BatteryLevel"),
            const SizedBox(height: 50),
            SimpleTimeSeriesChart.createLineCart(generateBatteryTimeSeries(testCaseDTO.userTestDaysDataDTO!)),
          ],
        ));

    return widget;
  }

  Widget _buildForegroundServiceChart(BuildContext context, UserSensorGeolocationDataDTO testCaseDTO) {
    final widget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.3,
        child: const Column(
          children: [
            Text("Foreground service"),
            SizedBox(height: 50),
            //SimpleTimeSeriesChart.createLineCart(generateTimeSeries(testCaseDTO.userTestDaysDataDTO)),
          ],
        ));

    return widget;
  }

  Widget _buildPhoneData(BuildContext context, UserSensorGeolocationDataDTO testCaseDTO) {
    final widget = Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
        child: Column(children: [
          Text("User: ${testCaseDTO.user} - UserId: ${testCaseDTO.userId}"),
          Text("Brand: ${testCaseDTO.brand} - ${testCaseDTO.model}"),
          Text("SDK: ${testCaseDTO.sdk}"),
          Text("SensorCount: ${testCaseDTO.sensorCount}"),
        ]));

    return widget;
  }

  Widget _buildCalendar(
      BuildContext context,
      WidgetRef ref,
      UserSensorGeolocationDataDTO testCaseDTO,
      StateNotifierProvider<LocationMapNotifier, Object?> locationMapNotifierProvider,
      StateNotifierProvider<ClusterNotifier, Object?> clusterNotifierProvider,
      StateNotifierProvider<DensityClusterNotifier, Object?> densityClusterNotifierProvider) {
    var day = DateTime.fromMillisecondsSinceEpoch(testCaseDTO.userTestDaysDataDTO![0].trackedDay.day);
    var test = TrackedDayDTO.toDataList(testCaseDTO.userTestDaysDataDTO!.map((e) => e.trackedDay).toList());

    final widget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.13,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(children: [
          const Text("Days"),
          const SizedBox(height: 10),
          CalendarWidget(test, (DateTime date) {
            final locationMapNotifier = ref.read(locationMapNotifierProvider.notifier);
            final clusterNotifier = ref.read(clusterNotifierProvider.notifier);
            final densityClusterNotifier = ref.read(densityClusterNotifierProvider.notifier);
            var index = testCaseDTO.userTestDaysDataDTO!.indexWhere((d) => DateTime.fromMillisecondsSinceEpoch(d.trackedDay.day).day == date.day);

            if (index == -1) {
              return;
            }

            locationMapNotifier.showOnMapAsync(testCaseDTO.userTestDaysDataDTO![index]);
            clusterNotifier.createClusters(testCaseDTO.userTestDaysDataDTO![index].testRawdata[0]);
            densityClusterNotifier.createClusters(testCaseDTO.userTestDaysDataDTO![index].testRawdata);
          }),
        ]));

    return widget;
  }
}
