import 'package:flutter/material.dart';
import 'package:marketlens/home_page.dart';   
import 'package:marketlens/widgets/mei_gauge.dart';


void main() {
  runApp(const MarketLensApp());
}

class MarketLensApp extends StatelessWidget {
  const MarketLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}