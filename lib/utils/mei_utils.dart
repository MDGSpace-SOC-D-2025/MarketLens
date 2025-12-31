import 'package:flutter/material.dart';

String getEmotion(int mei_value){
  if (mei_value<=40) {
    return "Fear 😟";
  }
  if (mei_value<=60) {
    return "Neutral 😐";
  }
  else {
    return "Greed 😄";
  }
}

String describeEmotion(int mei_value){
  if (mei_value<=40) {
    return "Market participants are risk-averse. Caution is advised.";
  }
  if (mei_value<=60) {
    return "Market sentiment is balanced with no strong bias.";
  }
  else {
    return "Optimism dominates the market. Risk appetite is high.";
  }
}

Color? getTrendColor (String trend){
  if (trend=="Strongly Bearish") {
    final trendColor=const Color.fromARGB(255, 223, 16, 2);
    return trendColor;
  }
  if (trend=="Bearish") {
    final trendColor=Colors.redAccent;
    return trendColor;
  }
  if (trend=="Uncertain/Neutral") {
    final trendColor=Colors.yellowAccent;
    return trendColor;
  }
  if (trend=="Bullish") {
    final trendColor=Colors.lightGreenAccent;
    return trendColor;
  }
  if (trend=="Strongly Bullish") {
    final trendColor=const Color.fromARGB(255, 11, 238, 19);
    return trendColor;
  }
  
  
}

Color getChartcolor(String trendDirection){
  if (trendDirection == '📈 rising') {
    final chartcolor = Colors.green;
    return chartcolor;
} else if (trendDirection == '📉 falling') {
    final chartcolor = Colors.red;
    return chartcolor;
} else {
    final chartcolor = Colors.grey;
    return chartcolor;
}
}