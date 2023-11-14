import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../extentions.dart';
import '../../color_pallet.dart';
import '../../infrastructure/repositories/dtos/location_category_overview_dto.dart';

class StatusRing extends StatelessWidget {
  final List<LocationCategoryOverviewDTO>? categories;
  final int selectedIndex;

  const StatusRing({required this.categories, required this.selectedIndex});

  List<PieChartSectionData> _showingSections(List<double> percentages) {
    return List.generate(categories!.length, (i) {
      final radius = selectedIndex == i ? 50.0 : 40.0;
      final fontSize = selectedIndex == i ? 20.0 : 14.0;
      return PieChartSectionData(
        color: HexColor.fromHex(categories![i].iconColor!),
        showTitle: true,
        value: percentages[i],
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize * f, fontWeight: FontWeight.bold, color: ColorPallet.darkTextColor),
      );
    });
  }

  double _doubleWithFraction(double val, int places) {
    final mod = pow(10.0, places) as double;
    return (val * mod).round().toDouble() / mod;
  }

  bool _checkPercentages(List<double> percentages) {
    final t = percentages.where((element) => element > 0.1).toList();
    return t.isNotEmpty;
  }

  List<double> _calculatePercentages() {
    var cnt = 0;
    final result = List<double>.filled(categories!.length, 0);
    var totalSeconds = 0;

    for (final e in categories!) {
      totalSeconds += e.seconds!;
    }
    print('TotalSeconds: [$totalSeconds]');

    for (final element in categories!) {
      final val = totalSeconds > 0 ? (element.seconds! / totalSeconds) * 100 : 0.0;
      result[cnt++] = _doubleWithFraction(val, 1);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final values = _calculatePercentages();
    final showStatusRing = _checkPercentages(values);
    return showStatusRing
        ? PieChart(
            PieChartData(
                borderData: FlBorderData(
                  show: false,
                ),
                startDegreeOffset: 270,
                sectionsSpace: 0,
                centerSpaceRadius: 75,
                sections: _showingSections(values)),
          )
        : Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text('No Data Available'),
          ]);
  }
}
