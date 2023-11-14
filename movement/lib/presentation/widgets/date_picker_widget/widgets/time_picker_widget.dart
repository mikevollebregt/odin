import 'package:flutter/cupertino.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../util/date_extensions.dart';
import 'number_picker_widget.dart';

class TimePickerWidget extends StatefulWidget {
  final DateTime date;
  final Function(DateTime) onChanged;
  final DateTime? maxDate;
  final DateTime? minDate;

  TimePickerWidget({
    required this.date,
    required this.onChanged,
    this.maxDate,
    this.minDate,
  });

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110 * y,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150 * x,
            child: NumberPickerWidget(
              selectedDate: widget.date,
              isHour: true,
              onChanged: (hour) {
                widget.onChanged(widget.date.copyWith(hour: hour));
              },
              maxDate: widget.maxDate,
            ),
          ),
          Text(':'),
          SizedBox(
            width: 150 * x,
            child: NumberPickerWidget(
              selectedDate: widget.date,
              isHour: false,
              onChanged: (minute) {
                widget.onChanged(widget.date.copyWith(minute: minute));
              },
              maxDate: widget.maxDate,
            ),
          ),
        ],
      ),
    );
  }
}
