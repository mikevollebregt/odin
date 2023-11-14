import 'package:desktop/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infastructure/period_classifier/enums/stop_enum.dart';

class DropdownReasonWidget extends ConsumerStatefulWidget {
  const DropdownReasonWidget({Key? key}) : super(key: key);

  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends ConsumerState<DropdownReasonWidget> {
  var stops = StopEnum.values.map((e) => e.toString().replaceAll("StopEnum.", "")).toList();
  var stop = "Home";

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(validatedNotifierProvider.notifier);
    return DropdownButton<String>(
      value: stop,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newStop) {
        notifier.setReason(newStop!);
        setState(() {
          stop = newStop;
        });
      },
      items: stops.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
