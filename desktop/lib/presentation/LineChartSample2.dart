// ignore_for_file: unnecessary_new

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  const SimpleTimeSeriesChart(this.seriesList, this.animate, {super.key});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.createLineCart(List<TimeSeriesPing> data) {
    return new SimpleTimeSeriesChart(
      _createLineCart(data),
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.width * 0.12,
        child: charts.TimeSeriesChart(
          seriesList as List<Series<dynamic, DateTime>>,
          animate: animate,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        ));
  }

  static List<charts.Series<TimeSeriesPing, DateTime>> _createLineCart(List<TimeSeriesPing> data) {
    return [
      new charts.Series<TimeSeriesPing, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesPing serie, _) => serie.time,
        measureFn: (TimeSeriesPing serie, _) => serie.ping,
        data: data,
      )
    ];
  }
}

class TimeSeriesPing {
  final DateTime time;
  final int ping;

  TimeSeriesPing(this.time, this.ping);
}
