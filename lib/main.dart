import 'package:flutter/material.dart';
import 'package:marketlens/market_state.dart';
import 'package:marketlens/pages/main_scaffold.dart';
import 'package:marketlens/pages/home_page.dart';   
import 'package:marketlens/widgets/mei_gauge.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => MarketState()..initialize(),
      child: const MarketLensApp(),
    ));
}

class MarketLensApp extends StatelessWidget {
  const MarketLensApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainScaffold(),
    );
  }
}
