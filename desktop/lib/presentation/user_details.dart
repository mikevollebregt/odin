import 'package:desktop/presentation/widgets/dropdown_reason_widget.dart';
import 'package:desktop/presentation/widgets/dropdown_verhicle_widget.dart';
import 'package:desktop/presentation/widgets/movement_tile_widget.dart';
import 'package:desktop/presentation/widgets/stop_tile_widget.dart';
import 'package:desktop/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infastructure/notifiers/generic_notifier.dart';
import '../infastructure/notifiers/location_map_notifier.dart';
import '../infastructure/repositories/dtos/classified_period_dto.dart';
import '../infastructure/repositories/dtos/google_details_dto.dart';
import '../infastructure/repositories/dtos/movement_dto.dart';
import '../infastructure/repositories/dtos/stop_dto.dart';
import '../infastructure/repositories/dtos/tracked_day_dto.dart';
import '../infastructure/repositories/dtos/user_sensor_geolocation_data_dto.dart';
import '../infastructure/repositories/dtos/user_sensor_geolocation_day_data_dto.dart';
import 'LineChartSample2.dart';
import 'calendar/CalendarWidget.dart';
import 'location_map.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userDetailsNotifierProvider);

    if (state is Loaded<UserSensorGeolocationDataDTO>) {
      return Container(
          child: Column(children: [
        Row(children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.height,
              child: _buildTrackedDayOverview(state.loadedObject, ref)),
          Column(children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.15, height: MediaQuery.of(context).size.height * 0.18, child: _buildMovementCRUD(context, ref)),
            SizedBox(width: MediaQuery.of(context).size.width * 0.15, height: MediaQuery.of(context).size.height * 0.17, child: _buildStopCRUD(context, ref)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.height * 0.02,
              child: _buildUploadButton(context, ref),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.15, height: MediaQuery.of(context).size.height * 0.6, child: _builClassifiedPeriods()),
          ]),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15, child: _buildRawMap(locationMapNotifierProvider)),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15, child: _buildRawFusedMap(locationMapNotifierProvider))
                ],
              ),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15, child: _buildBalancedMap(locationMapNotifierProvider)),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15, child: _buildNormalCalculatedSpeedHeatMap(locationMapNotifierProvider))
                ],
              ),
            ],
          ),
          Column(
            children: [SizedBox(width: MediaQuery.of(context).size.width * 0.15, child: _buildGoogleDetails())],
          )
        ])
      ]));
    } else {
      return const Text("Loading..");
    }
  }

  Widget _builClassifiedPeriods() {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(validatedNotifierProvider.notifier);
      final state = ref.watch(validatedNotifierProvider);
      if (state is Loaded<List<ClassifiedPeriodDto>>) {
        var dtos = state.loadedObject;
        return SizedBox(
            width: 400, // fixed height
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: dtos.length,
              itemBuilder: (context, index) {
                final dto = dtos[index];
                if (dto is StopDto) {
                  return InkWell(
                    child: StopTile(dto),
                    onTap: () {
                      notifier.removePeriod(index);
                    },
                  );
                }
                if (dto is MovementDto) {
                  return InkWell(
                    child: Container(), //MovementTile(dto),
                    onTap: () {
                      notifier.removePeriod(index);
                    },
                  );
                }
                return const SizedBox();
              },
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildMovementCRUD(BuildContext context, WidgetRef ref) {
    var startHourController = TextEditingController();
    var startMinuteController = TextEditingController();
    var endHourController = TextEditingController();
    var endMinuteController = TextEditingController();

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'sh',
                  ),
                  controller: startHourController,
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'sm',
                  ),
                  controller: startMinuteController,
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'eh',
                  ),
                  controller: endHourController,
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'em',
                  ),
                  controller: endMinuteController,
                ))
          ],
        ),
        const DropdownVehicleWidget(),
        ElevatedButton(
          onPressed: () {
            final notifier = ref.watch(validatedNotifierProvider.notifier);
            notifier.setTimeMovement(int.parse(startHourController.value.text), int.parse(startMinuteController.value.text),
                int.parse(endHourController.value.text), int.parse(endMinuteController.value.text));
          },
          child: const Text('Save'),
        )
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        final notifier = ref.watch(validatedNotifierProvider.notifier);
        notifier.savePeriods();
      },
      child: Consumer(builder: (context, ref, child) {
        final state = ref.watch(validatedNotifierProvider);
        if (state is Loaded<List<ClassifiedPeriodDto>>) {
          return const Text("Upload");
        } else {
          return const Text("Busy");
        }
      }),
    );
  }

  Widget _buildStopCRUD(BuildContext context, WidgetRef ref) {
    var startHourController = TextEditingController();
    var startMinuteController = TextEditingController();
    var endHourController = TextEditingController();
    var endMinuteController = TextEditingController();

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'sh',
                  ),
                  controller: startHourController,
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'sm',
                  ),
                  controller: startMinuteController,
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'eh',
                  ),
                  controller: endHourController,
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'em',
                  ),
                  controller: endMinuteController,
                ))
          ],
        ),
        const DropdownReasonWidget(),
        ElevatedButton(
          onPressed: () {
            final notifier = ref.watch(validatedNotifierProvider.notifier);
            notifier.setTimeStop(int.parse(startHourController.value.text), int.parse(startMinuteController.value.text),
                int.parse(endHourController.value.text), int.parse(endMinuteController.value.text));
          },
          child: const Text('Save'),
        )
      ],
    );
  }

  Widget _buildCalendar(BuildContext context, WidgetRef ref, UserSensorGeolocationDataDTO testCaseDTO) {
    var day = DateTime.fromMillisecondsSinceEpoch(testCaseDTO.userTestDaysDataDTO![0].trackedDay.day);

    final locationMapNotifier = ref.read(locationMapNotifierProvider.notifier);

    final widget = SizedBox(
        width: MediaQuery.of(context).size.width * 0.13,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(children: [
          const Text("Days"),
          const SizedBox(height: 10),
          CalendarWidget(TrackedDayDTO.toDataList(testCaseDTO.userTestDaysDataDTO!.map((e) => e.trackedDay).toList()), (DateTime date) {
            var index = testCaseDTO.userTestDaysDataDTO!.indexWhere((d) => DateTime.fromMillisecondsSinceEpoch(d.trackedDay.day).day == date.day);

            if (index == -1) {
              return;
            }

            locationMapNotifier.showOnMapAsync(testCaseDTO.userTestDaysDataDTO![index]);
          }),
        ]));

    return widget;
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

  Widget _buildGoogleDetails() {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(googleDetailsNotifierProvider.notifier);
      final state = ref.watch(googleDetailsNotifierProvider);
      if (state is Loaded<GoogleDetailsDTO>) {
        return Column(children: [
          const Text("Google details"),
          const SizedBox(height: 10),
          Text(state.loadedObject.googlePlaceDTO.place),
          const SizedBox(height: 10),
          Text(DateTime.fromMillisecondsSinceEpoch(state.loadedObject.sensorGeolocationDTO.createdOn).toString())
        ]);
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
                    .map((e) => TimeSeriesPing(DateTime.fromMillisecondsSinceEpoch(e.createdOn), e.calculatedSpeed.toInt()))
                    .toList()),
              ],
            ));
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget _buildTrackedDayOverview(UserSensorGeolocationDataDTO testCaseDTO, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(children: _buildDays(testCaseDTO, ref)),
    );
  }

  List<Widget> _buildDays(UserSensorGeolocationDataDTO testCaseDTO, WidgetRef ref) {
    final list = <Widget>[];
    for (var dto in testCaseDTO.userTestDaysDataDTO!) {
      list.add(_buildItems(dto, ref));
    }

    return list;
  }

  Widget _buildItems(UserSensorGeolocationDayDataDTO day, WidgetRef ref) {
    return InkWell(
      child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(children: [
            Text("Day: ${DateTime.fromMillisecondsSinceEpoch(day.trackedDay.day)}"),
            Text("AmountOfPoints: ${day.rawdata.length}"),
          ])),
      onTap: () {
        final locationMapNotifier = ref.read(locationMapNotifierProvider.notifier);
        final validatedNotifier = ref.watch(validatedNotifierProvider.notifier);

        validatedNotifier.setDate(DateTime.fromMillisecondsSinceEpoch(day.trackedDay.day));
        locationMapNotifier.showOnMapAsync(day);
      },
    );
  }
}
