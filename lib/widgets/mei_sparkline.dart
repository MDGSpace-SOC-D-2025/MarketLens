import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MeiSparkline extends StatelessWidget {
  final List<int> values;
  final Color color;

  const MeiSparkline({
    super.key,
    required this.values,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const SizedBox(height: 40);
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < values.length; i++) {
      spots.add(FlSpot(i.toDouble(), values[i].toDouble()));
    }

    return SizedBox(
      height: 50,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 2,
              dotData: FlDotData(show: false),
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
