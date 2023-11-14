import 'package:desktop/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infastructure/period_classifier/enums/transport_enum.dart';

class DropdownVehicleWidget extends ConsumerStatefulWidget {
  const DropdownVehicleWidget({Key? key}) : super(key: key);

  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends ConsumerState<DropdownVehicleWidget> {
  var transports = Transport.values.map((e) => e.toString().replaceAll("Transport.", "")).toList();
  var transport = "Walking";

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(validatedNotifierProvider.notifier);
    return DropdownButton<String>(
      value: transport,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? vehicle) {
        notifier.setVehicle(vehicle!);
        setState(() {
          transport = vehicle;
        });
      },
      items: transports.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
