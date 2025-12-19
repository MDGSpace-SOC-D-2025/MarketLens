import 'package:flutter/material.dart';
import 'package:marketlens/widgets/mei_gauge.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

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
  

  @override
  Widget build(BuildContext context) {
    const int mei_value=55;

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
                                  
          ],
        ),
      
    

    );
  }
}