import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MeiLineChart extends StatelessWidget {

  final List <int> values;

  const MeiLineChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.length==0) {
      return SizedBox(
        height: 200,
        child: Center(child: Text("NO MEI HISTORY YET", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)),
      );

    }
 
    final List<FlSpot> spots=[];

    for (int i=0;i<values.length;i++){
      spots.add(FlSpot(i.toDouble(), values[i].toDouble()));
    }
    
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100.0,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: true),
              color: Colors.lightBlue,
            )
          ]
        )
      ),
    );
  }
}

