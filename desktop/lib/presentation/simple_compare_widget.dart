// import 'package:desktop/infastructure/notifiers/generic_notifier.dart';
// import 'package:desktop/infastructure/notifiers/simple_algo_notifier.dart';
// import 'package:desktop/infastructure/repositories/dtos/test_case_results_dto.dart';
// import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SimpleCompareWidget extends ConsumerWidget {
//   final TestCaseDTO testCaseDTO;
//   late StateNotifierProvider<SimpleAlgoNotifier, dynamic> algoProvider;

//   SimpleCompareWidget(this.testCaseDTO, {Key? key}) : super(key: key) {
//     algoProvider = StateNotifierProvider((ref) => SimpleAlgoNotifier(testCaseDTO));
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(algoProvider);
//     if (state is Loaded<TestCaseResultsDTO>) {
//       var dto = state.loadedObject;
//       return Container(
//           padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
//           child: Column(children: [
//             Text("algo 2"),
//             Text(
//                 "Locaties: ${dto.generatedTrackedLocations.length}/${dto.validatedTrackedLocations.length} - %${_getPercentage(dto.generatedTrackedLocations.length, dto.validatedTrackedLocations.length)}"),
//             Text("Verplaastingen: 0/0 - 0%")
//           ]));
//     } else {
//       return const CircularProgressIndicator();
//     }
//   }

//   String _getPercentage(int generated, int validated) {
//     return (generated / validated * 100).toStringAsFixed(2);
//   }
// }
