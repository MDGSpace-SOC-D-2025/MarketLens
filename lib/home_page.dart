import 'package:flutter/material.dart';
import 'package:marketlens/mei_service.dart';
import 'package:marketlens/widgets/mei_gauge.dart';
import 'dart:async';

class HomePage extends StatefulWidget { 

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    late MEIService meiService;
    late int mei_value;
    late int prev_mei_value;
    late Color trendColor=Colors.cyanAccent;
    late Timer meiTimer;


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

  String marketTrend(){
    if (mei_value > prev_mei_value) {
      trendColor=Colors.green;
      return "↑ Increasing";
      

    }
    else if (mei_value < prev_mei_value){
     trendColor=Colors.red;
     return "↓ Decreasing";
    
    }
    else{
       trendColor=Colors.yellow;
      return "→ Stable";

    }
  }

void startAutoUpdate() {
  meiTimer=Timer.periodic(const Duration(seconds: 5), (timer) {
    setState(() {
      prev_mei_value = mei_value;
      mei_value = meiService.getNextValue();
    });
  });
}

 

  @override
  void initState(){
    super.initState();
    meiService=MEIService();
    
    mei_value=meiService.getCurrentValue(); 

    prev_mei_value=mei_value;   
    startAutoUpdate();
  }

   @override
  void dispose(){
    meiTimer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


      return Scaffold(
      
      appBar: AppBar(
        title: Text("MarketLens", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24,),
            MEIGauge(value: mei_value,),
            const SizedBox(height: 24,),
            Center(
              child: Text(
                getEmotion(mei_value), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8,),
            Center(
              child: Text(
                describeEmotion(mei_value), style: TextStyle(fontSize: 14, color: Colors.grey ),
              ),
            ),
            const SizedBox(height: 16,),
            Text(
              marketTrend(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: trendColor
            )),
            const SizedBox(height: 24,),
                                
          ],
        ),
    );
  }
}