import 'package:desktop/presentation/calendar/status_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calendar_properties.dart';
import 'color_pallet.dart';

class CalendarWidget extends ConsumerWidget {
  final List<CalendarPageDayData> calendarData;
  final Function(DateTime) onDatePressed;

  const CalendarWidget(this.calendarData, this.onDatePressed, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late double initialSwipe;
    late double distanceSwiped;
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        initialSwipe = details.globalPosition.dx;
      },
      onPanUpdate: (DragUpdateDetails details) {
        distanceSwiped = details.globalPosition.dx - initialSwipe;
      },
      onPanEnd: (DragEndDetails details) {
        initialSwipe = 0.0;
        if (distanceSwiped < 50) {
          ref.read(calendarNotifierProvider).goForwardMonth();
        }
        if (distanceSwiped > 50) {
          ref.read(calendarNotifierProvider).goBackMonth();
        }
      },
      child: _CalendarWidget(calendarData, onDatePressed),
    );
  }
}

class _CalendarWidget extends ConsumerStatefulWidget {
  final List<CalendarPageDayData> calendarData;
  final Function(DateTime) onDatePressed;
  final daysOfWeekStrings = ['M', 'D', 'W', 'D', 'V', 'Z', 'Z'];

  _CalendarWidget(this.calendarData, this.onDatePressed);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends ConsumerState<_CalendarWidget> {
  @override
  void initState() {
    ref.read(calendarNotifierProvider).setDates(widget.calendarData);
    ref.read(calendarNotifierProvider).computeProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var c = 0; c < 7; c++)
                  Expanded(
                    child: Consumer(builder: (context, ref, _) {
                      final cv = ref.watch(calendarNotifierProvider).calendarValues;
                      return _CalenderColumn([
                        {
                          textValueText: widget.daysOfWeekStrings[c],
                          firstDayOfExperimentText: false,
                          lastDayOfExperimentText: false,
                          isTitleText: true,
                          greyValueText: false,
                          inExperimentText: false,
                          isValidatedText: false,
                          isUnvalidatedText: false,
                          isMissingText: false,
                          isTodayText: false,
                          confirmed: false
                        },
                        cv[c],
                        cv[c + 7],
                        cv[c + 14],
                        cv[c + 21],
                        cv[c + 28],
                        cv[c + 35],
                      ], widget.onDatePressed);
                    }),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CalenderColumn extends StatelessWidget {
  final List<Map> columnValues;
  final Function(DateTime) onDatePressed;

  const _CalenderColumn(this.columnValues, this.onDatePressed);

  List<Color> _getBackgroundColor(Map value) {
    if (value[firstDayOfExperimentText]) {
      return [ColorPallet.veryLightBlue, Colors.transparent];
    } else if (value[lastDayOfExperimentText]) {
      return [Colors.transparent, ColorPallet.veryLightBlue];
    } else if (value[inExperimentText]) {
      return [ColorPallet.veryLightBlue, ColorPallet.veryLightBlue];
    } else {
      return [Colors.transparent, Colors.transparent];
    }
  }

  Widget _getConfirmedRing(Map value) {
    if (value[isTodayText]) {
      return const StatusRing(
        missing: 0.0,
        validated: 4.0,
        unvalidated: 0,
      );
    } else {
      return Container(
        decoration: const BoxDecoration(color: Color(0xFFAFCB05), shape: BoxShape.circle),
      );
    }
  }

  Widget _getStatusRing(Map value) {
    if (value[inExperimentText]) {
      return StatusRing(
        missing: value[isMissingText],
        validated: value[isValidatedText],
        unvalidated: value[isUnvalidatedText],
      );
    } else {
      return Container();
    }
  }

  Color _getCircleColor(Map value) {
    if (value[isTodayText]) {
      return ColorPallet.primaryColor;
    } else if (value[inExperimentText]) {
      return ColorPallet.veryLightBlue;
    } else {
      return Colors.transparent;
    }
  }

  Color _getTextColor(Map value) {
    if (value[isTodayText]) {
      return Colors.white;
    }
    if (value[greyValueText] &&
        (value[isValidatedText].runtimeType is double || value[isUnvalidatedText].runtimeType is double || value[isMissingText].runtimeType is double)) {
      return ColorPallet.veryLightGray;
    } else if (value[isTodayText]) {
      return ColorPallet.darkTextColor;
    } else if (value[greyValueText]) {
      return ColorPallet.midGray;
    } else {
      return ColorPallet.darkTextColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidgets = columnValues.map((Map value) {
      return Container(
        height: 36.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _getBackgroundColor(value), begin: Alignment.centerRight, end: Alignment.centerLeft, stops: const [0.5, 0.5]),
        ),
        child: InkWell(
          onTap: () {
            if (value[isTitleText] == false) {
              final date = DateTime(value[yearText], value[monthText], value[dayText]);
              onDatePressed(date);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getCircleColor(value),
            ),
            child: Stack(
              children: [
                value[confirmed] ? _getConfirmedRing(value) : _getStatusRing(value),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    value[textValueText],
                    style:
                        TextStyle(fontFamily: 'Akko Pro', fontWeight: FontWeight.w500, fontSize: value[isTitleText] ? 18.0 : 16.0, color: _getTextColor(value)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    return Column(
      children: textWidgets,
    );
  }
}
