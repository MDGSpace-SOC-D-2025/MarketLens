import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:marketlens/mei_model.dart';

class MeiLineChart extends StatelessWidget {
  final List<int> values;
  final Color linecolor;

  const MeiLineChart({
    super.key,
    required this.values,
    required this.linecolor,
  });

  static const int maxPoints = 6; // Now + last 10h (2h steps)

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "NO MEI HISTORY YET",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    /// Take only last 6 points
    final visibleValues = values.length > maxPoints
        ? values.sublist(values.length - maxPoints)
        : values;

    final spots = <FlSpot>[];
    for (int i = 0; i < visibleValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), visibleValues[i].toDouble()));
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (visibleValues.length - 1).toDouble(),
          minY: 0,
          maxY: 100,

          clipData: FlClipData.all(),

          gridData: FlGridData(
            show: true,
            horizontalInterval: 20,
          ),

          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final hoursAgo =
                      (visibleValues.length - 1 - index) * 2;

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      hoursAgo == 0 ? "Now" : "${hoursAgo}h ago",
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: true),
              color: linecolor,
            ),
          ],
        ),
      ),
    );
  }
}
