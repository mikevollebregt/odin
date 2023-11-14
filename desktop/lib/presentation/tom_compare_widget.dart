import 'package:desktop/infastructure/notifiers/generic_notifier.dart';
import 'package:desktop/infastructure/repositories/dtos/test_case_results_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infastructure/notifiers/tom_compare_notifier.dart';

class TomCompareWidget extends ConsumerWidget {
  late StateNotifierProvider<TomCompareNotifier, dynamic> tomAlgoProvider;

  TomCompareWidget(StateNotifierProvider<TomCompareNotifier, dynamic> provider, {Key? key}) : super(key: key) {
    tomAlgoProvider = provider;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tomAlgoProvider);
    if (state is Loaded<TestCaseResultsDTO>) {
      var dto = state.loadedObject;
      return Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Column(children: [
            const Text("algo tom"),
            const SizedBox(
              height: 30,
            ),
            const Text("Locaties"),
            const SizedBox(
              height: 10,
            ),
            Text("Validated: ${dto.validatedTrackedLocations.length}"),
            Text("Generated: ${dto.generatedTrackedLocations.length}"),
            Text(
                "Matches: ${dto.mappedTrackedLocations.length} - % ${_getPercentage(dto.mappedTrackedLocations.length, dto.validatedTrackedLocations.length)}"),
            const SizedBox(
              height: 30,
            ),
            const Text("Verplaastingen"),
            const SizedBox(
              height: 10,
            ),
            Text("Validated: ${dto.validatedTrackedMovement.length}"),
            Text("Generated: ${dto.generatedTrackedMovement.length}"),
            Text("Matches: ${dto.mappedTrackedMovement.length} - % ${_getPercentage(dto.mappedTrackedMovement.length, dto.validatedTrackedMovement.length)}")
          ]));
    } else {
      return const CircularProgressIndicator();
    }
  }

  String _getPercentage(int generated, int validated) {
    var percentage = generated / validated * 100;

    if (percentage.isNaN) {
      percentage = 0;
    }

    return percentage.toStringAsFixed(2);
  }
}
