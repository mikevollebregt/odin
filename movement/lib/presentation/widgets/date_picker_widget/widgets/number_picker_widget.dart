import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';

import '../../../../infrastructure/notifiers/responsive_ui.dart';
import '../util/date_extensions.dart';

class NumberPickerWidget extends StatelessWidget {
  final DateTime selectedDate;
  final bool isHour;
  final DateTime? maxDate;
  final Function(int) onChanged;

  NumberPickerWidget({
    required this.selectedDate,
    required this.onChanged,
    required this.isHour,
    this.maxDate,
  });

  List<int> getPickerValues() {
    List<int> values;
    if (isHour) {
      values = [for (var i = 0; i < 24; i += 1) i];
      if (maxDate != null && selectedDate.isSameDay(maxDate!)) values = values.where((v) => v <= maxDate!.hour).toList();
    } else {
      values = [for (var i = 0; i < 60; i += 1) i];
      if (maxDate != null && selectedDate.isSameDayAndHour(maxDate!)) values = values.where((v) => v <= maxDate!.minute).toList();
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final values = getPickerValues();
    final startValue = isHour ? selectedDate.hour : selectedDate.minute;
    final fixedExtentScrollController = new FixedExtentScrollController(initialItem: startValue);

    if (Platform.isIOS) {
      return CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: values.indexOf(startValue)),
        magnification: 1.35,
        squeeze: 1,
        itemExtent: 30 * y,
        selectionOverlay: SizedBox(),
        onSelectedItemChanged: (int selectedItem) {
          onChanged(values[selectedItem]);
        },
        children: List<Widget>.generate(
          values.length,
          (int index) {
            return Center(
              child: Text(
                values[index].toString().padLeft(2, '0'),
              ),
            );
          },
        ),
      );
    }

    return ListWheelScrollView(
      overAndUnderCenterOpacity: 0.5,
      controller: fixedExtentScrollController,
      magnification: 1.6,
      diameterRatio: 1.3,
      onSelectedItemChanged: (int selectedItem) {
        onChanged(values[selectedItem]);
      },
      children: List<Widget>.generate(values.length, (int index) {
        return Center(
          child: Text(
            style: TextStyle(fontSize: 16 * f),
            values[index].toString().padLeft(2, '0'),
          ),
        );
      }),
      itemExtent: 35.0 * y,
    );
  }
}
