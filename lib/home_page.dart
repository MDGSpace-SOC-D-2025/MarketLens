import 'dart:convert';

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
    late String trend;
    
    late Color trendColor;
    late Timer meiTimer;

    late String stock_code;
    late List<dynamic> stock_headlines;

    final List<String> availableStocks=['AAPL', 'TSLA', 'NIFTY'];


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

  Color? getTrendColor (){
    if (trend=="Strongly Bearish") {
      trendColor=const Color.fromARGB(255, 223, 16, 2);
      return trendColor;
    }
    if (trend=="Bearish") {
      trendColor=Colors.redAccent;
      return trendColor;
    }
    if (trend=="Uncertain/Neutral") {
      trendColor=Colors.yellowAccent;
      return trendColor;
    }
    if (trend=="Bullish") {
      trendColor=Colors.lightGreenAccent;
      return trendColor;
    }
    if (trend=="Strongly Bullish") {
      trendColor=const Color.fromARGB(255, 11, 238, 19);
      return trendColor;
    }
    
    
  }

  

void startAutoUpdate() async {
  meiTimer=Timer.periodic(const Duration(seconds: 5), (timer) async {
    final data1=await meiService.fetchJSON_StockMEIData(stock_code);
    setState(() {
      mei_value=data1.value;
      trend=data1.trend;
      stock_headlines=data1.headlines;
    });
  });
}

 

  @override
  void initState(){
    super.initState();

    meiService=MEIService();
    
    mei_value=0; 

    trend='--NA--'; 

    stock_code="AAPL";

    stock_headlines=[];

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
            const SizedBox(height: 8),
            Row(children: [
              Text("Stocks:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              const SizedBox(width: 12,),
              DropdownButton<String>(
                value: stock_code,
                items: availableStocks.map((code){
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Text(code)  
                  );                
                }).toList(), 
                onChanged: (newvalue){
                  setState(() {
                    stock_code=newvalue!;
                    stock_headlines=[];
                  });
                })
            ],),

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
              trend, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: getTrendColor()
            )),
            const SizedBox(height: 24,),       

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("LATEST  HEADLINES  📰 📢❗️", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 24,),

            Expanded(
              child: ListView.builder(
                itemCount: stock_headlines.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.article_outlined),
                    title: Text(stock_headlines[index]),
                  );
                },
              ),
            ),
                             
                                
          ],
        ),
    );
  }
}