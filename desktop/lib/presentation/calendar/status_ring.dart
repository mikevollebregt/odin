import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'color_pallet.dart';

List<PieChartSectionData> _showingSections(
  double missing,
  double validated,
  double unvalidated,
) {
  return List.generate(3, (i) {
    const radius = 5.0;
    switch (i) {
      case 0:
        return PieChartSectionData(
          color: ColorPallet.lightGreen,
          showTitle: false,
          value: validated,
          radius: radius,
        );

      case 1:
        return PieChartSectionData(
          color: ColorPallet.orange,
          showTitle: false,
          value: unvalidated,
          radius: radius,
        );

      case 2:
        return PieChartSectionData(
          color: ColorPallet.veryLightBlue,
          showTitle: false,
          value: missing,
          radius: radius,
        );
      default:
        throw Error();
    }
  });
}

class StatusRing extends StatelessWidget {
  final double missing;
  final double validated;
  final double unvalidated;

  const StatusRing({super.key, required this.missing, required this.validated, required this.unvalidated});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
          borderData: FlBorderData(
            show: false,
          ),
          startDegreeOffset: 270,
          sectionsSpace: 0,
          centerSpaceRadius: 13,
          sections: _showingSections(missing, validated, unvalidated)),
    );
  }
}
