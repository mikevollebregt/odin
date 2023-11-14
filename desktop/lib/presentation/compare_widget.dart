// import 'package:desktop/infastructure/notifiers/algo_notifier.dart';
// import 'package:desktop/infastructure/notifiers/generic_notifier.dart';
// import 'package:desktop/infastructure/notifiers/simple_algo_notifier.dart';
// import 'package:desktop/infastructure/repositories/dtos/test_case_results_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';
// import 'package:desktop/providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CompareWidget extends ConsumerWidget {
//   final TestCaseDTO testCaseDTO;
//   late StateNotifierProvider<SimpleAlgoNotifier, dynamic> simpleAlgoProvider;

//   CompareWidget(this.testCaseDTO, {Key? key}) : super(key: key) {
//     simpleAlgoProvider = StateNotifierProvider((ref) => SimpleAlgoNotifier(
//           testCaseDTO,
//         ));
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(simpleAlgoProvider);
//     if (state is Loaded<TestCaseResultsDTO>) {
//       var dto = state.loadedObject;
//       return Container(
//           padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
//           child: Column(children: [
//             Text("algo 1"),
//             Text(
//                 "Locaties: V-${dto.validatedTrackedLocations.length} / G-${dto.generatedTrackedLocations.length} / M-${dto.mappedTrackedLocations} - %${_getPercentage(dto.mappedTrackedLocations.length, dto.validatedTrackedLocations.length)}"),
//             Text(
//                 "Verplaastingen: V-${dto.validatedTrackedMovement.length} / G-${dto.generatedTrackedMovement.length} / M-${dto.mappedTrackedMovement} - %${_getPercentage(dto.mappedTrackedMovement.length, dto.validatedTrackedMovement.length)}")
//           ]));
//     } else {
//       return const CircularProgressIndicator();
//     }
//   }

//   String _getPercentage(int generated, int validated) {
//     return (generated / validated * 100).toStringAsFixed(2);
//   }
// }
