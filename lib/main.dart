import 'package:flutter/material.dart';
import 'package:marketlens/market_state.dart';
import 'package:marketlens/pages/main_scaffold.dart';
  
import 'package:provider/provider.dart';


void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => MarketState()..initialize(),
      child: const MarketLensApp(),
    ));
}
//Root of my UI Tree
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

//MaterialApp is like the operating system of my app UI.
//Material → Android-style UI
/*
MaterialApp is the root widget that sets up a Material Design app.

It provides the basic infrastructure my app needs like:
Navigation, Theme, Text direction, Default UI behavior (buttons, dialogs, etc.)*/
