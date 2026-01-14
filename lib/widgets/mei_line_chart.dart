import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:marketlens/mei_model.dart';

class MeiLineChart extends StatelessWidget {

  final List<int> values;
  final Color linecolor;

  const MeiLineChart({super.key, required this.values, required this.linecolor});

  @override
  Widget build(BuildContext context) {
    if (values.length==0) {
      return SizedBox(
        height: 200,
        child: Center(child: Text("NO MEI HISTORY YET", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)),
      );

    }
 
    final List <FlSpot> spots = [];
    for (int i=0;i<values.length;i++){ 
      spots.add(FlSpot(i.toDouble(), values[i].toDouble())); 
    }

    
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
  minX: 0,
  maxX: (values.length - 1).toDouble(), // 👈 IMPORTANT
  minY: 0,
  maxY: 100,

  clipData: FlClipData.all(), // 👈 IMPORTANT

  gridData: FlGridData(
    show: true,
    horizontalInterval: 20,
  ),

  extraLinesData: ExtraLinesData(
    horizontalLines: [
      HorizontalLine(
        y: 100,
        color: const Color.fromARGB(255, 51, 80, 66),
        strokeWidth: 1,
        dashArray: [4, 4],
      ),
    ],
  ),

  borderData: FlBorderData(show: false),

  titlesData: FlTitlesData(
    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 42,
        interval: 20,
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
          final hoursAgo = (values.length - 1 - index) * 2;
          if (hoursAgo < 0) return const SizedBox.shrink();
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
)

      ),
    );
  }
}

