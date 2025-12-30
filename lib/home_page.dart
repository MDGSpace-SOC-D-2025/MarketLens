import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketlens/mei_service.dart';
import 'package:marketlens/widgets/mei_gauge.dart';
import 'dart:async';

import 'package:marketlens/widgets/mei_line_chart.dart';


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

    String trendDirection='Unknown';
    int MomentumScore=0;
    String MomentumStrength='Unknown';
    String volatilityLevel='Unknown';

    late Color chartcolor;

    bool isloading=false;
    String? errorMessage;

    List<int> meiHistory = []; 


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

  Color getChartcolor(){
    if (trendDirection == '📈 rising') {
      chartcolor = Colors.green;
      return chartcolor;
  } else if (trendDirection == '📉 falling') {
      chartcolor = Colors.red;
      return chartcolor;
  } else {
      chartcolor = Colors.grey;
      return chartcolor;
  }
  }


Future<void> fetchAlldata() async {

  if (isloading) return;

  try { 
    setState(() {
      isloading=true;
      errorMessage=null;
    }); 

    final data1=await meiService.fetchJSON_StockMEIData(stock_code);
    final history_mei_values = await meiService.fetchMEIHistory(stock_code);
    final trendData= await meiService.fetchMEItrend(stock_code);

    if (!mounted) return;

    setState(() {
      mei_value=data1.value;
      trend=data1.trend;
      stock_headlines=data1.headlines;

      meiHistory=history_mei_values;

      trendDirection=trendData['Trend']['direction'];
      MomentumScore=trendData['Momentum Score']['value'];
      MomentumStrength=trendData['Momentum Score']['strength'];
      volatilityLevel=trendData['Volatility Indicator']['level'];

      isloading=false;

    });
  } catch (e) {
    if (!mounted) return;
    setState(() {
      isloading=false;
      errorMessage='Unable to fetch market data';
    });
  }

}
  

void startAutoUpdate() async {
  fetchAlldata();


  meiTimer=Timer.periodic(const Duration(seconds: 15), (timer) async {
    fetchAlldata();  
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
      
      body:  SafeArea(
        child: Column(              
              children: [               
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
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
                        fetchAlldata();
                      },)
                  ],),
                ),
          
                Expanded(
                  child: isloading
      ? const Center(child: CircularProgressIndicator())
      : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : RefreshIndicator(
                    onRefresh: fetchAlldata,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  TweenAnimationBuilder<int>
                                  (
                                    tween: IntTween(begin: 0, end: mei_value),
                                    duration: const Duration(milliseconds: 700),
                                    builder: (context, value, _){
                                      return MEIGauge(value: mei_value);
                                    },
                                    ),
                    
                                  const SizedBox(height: 24),
                    
                                  // FIXED HEIGHT
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 800),
                                    child: SizedBox(
                                      height: 220,
                                      child: MeiLineChart(
                                      values: meiHistory,
                                      linecolor: getChartcolor(),
                                      ),
                                    ),
                                  ),
                    
                                  //const SizedBox(height: 16),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(thickness: 0.6),
                                  ),

                    
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                    child: Column(
                                      children: [
                                        Text("Trend: $trendDirection"),
                                        Text("Momentum: $MomentumScore ($MomentumStrength)"),
                                        Text("Volatility: $volatilityLevel"),
                                      ],
                                    ),
                                    ),
                                  ),
                    
                                  Center(
                                    child: Text(
                                    getEmotion(mei_value),
                                    style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                    ),
                                  ),
                    
                                  const SizedBox(height: 8),
                    
                                  Center(
                                    child: Text(
                                    describeEmotion(mei_value),
                                    style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                    
                                  const SizedBox(height: 16),
                    
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        trend,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: getTrendColor(),
                                        ),
                                    ),
                                  ),
                    
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                  "LATEST HEADLINES 📰 📢 🚨",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                    
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: stock_headlines.length,
                                    itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(Icons.article_outlined),
                                      title: Text(stock_headlines[index]),
                                    );
                                    },
                                  ),
                                ],
                              ),
                            ),
                  ),
      ),
    ],
  ),
),
      
    );
  }
}