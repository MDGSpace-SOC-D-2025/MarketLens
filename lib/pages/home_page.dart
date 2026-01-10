import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketlens/market_state.dart';
import 'package:marketlens/pages/assistant_page.dart';
import 'package:marketlens/mei_service.dart';
import 'package:marketlens/utils/mei_utils.dart';

import 'package:marketlens/widgets/alert_card.dart';
import 'package:marketlens/widgets/insights_card.dart';
import 'package:marketlens/widgets/mei_gauge.dart';
import 'dart:async';

import 'package:marketlens/widgets/mei_line_chart.dart';
import 'package:marketlens/widgets/stock_search_delegate.dart';
import 'package:provider/provider.dart';

final List<String> stocks = ['AAPL', 'TSLA', 'NIFTY'];

class HomePage extends StatelessWidget { 

  const HomePage({super.key});

    /*late MEIService meiService;
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

    String Mom_explain='NA';
    String Vol_explain='NA';
    String Trend_explain='NA';

    late Color chartcolor;

    bool isloading=false;
    String? errorMessage;

    String alertMessage = '';
    String alertLevel = '';
    String alertTitle='';
    List<dynamic> alertFactors=[];

    String insightTitle='';
    String insightMessage='';
    String insightType='';

    List<int> meiHistory = []; 




    final List<String> availableStocks=['AAPL', 'TSLA', 'NIFTY'];


//


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

      Trend_explain=trendData['Trend']['explanation'];
      Mom_explain= trendData['Momentum Score']['explanation'];
      Vol_explain=trendData['Volatility Indicator']['explanation'];

      alertMessage=trendData['Alert']['message'];
      alertLevel=trendData['Alert']['level'];
      alertTitle=trendData['Alert']['title'];
      alertFactors=trendData['Alert']['factors'];

      insightTitle=trendData['Insight']['title'];
      insightMessage=trendData['Insight']['message'];
      insightType=trendData['Insight']['type'];

      

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
  }*/

  
  @override
  Widget build(BuildContext context) {

      final market = context.watch<MarketState>();

      return Scaffold(
      
      appBar: AppBar(
        title: Column( 
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("MarketLens", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
            
            Text(
        context.watch<MarketState>().stockCode,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.grey,
          letterSpacing: 1.2
        ),
      ),
      
          ],
        ),
        centerTitle: true,
         actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        final stock = await showSearch(
          context: context,
          delegate: StockSearchDelegate(),
        );

        if (stock != null && context.mounted) {
          context.read<MarketState>().changeStock(stock.code);
        }
      },
    ),
  ],
      ),
      
      /*floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.smart_toy_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AssistantPage(),
              ),
            );
          },
        ),*/


      
      body:  SafeArea(
        child: Column(              
              children: [               
                /*Row(children: [
                  Text("Stocks:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  const SizedBox(width: 12,),
                 /* DropdownButton<String>(
                      value: market.stockCode,
                      items: stocks.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          market.changeStock(val);
                        }
                      },
                    )*/
                
                ],),*/

                

                
          
                Expanded(
                  child: market.isLoading
      ? const Center(child: CircularProgressIndicator())
      : market.error != null
          ? Center(
              child: Text(
                market.error!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : RefreshIndicator(
                    onRefresh: market.fetchAll,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                          const SizedBox(height: 32),

                                          

                                  TweenAnimationBuilder<int>
                                  (
                                    tween: IntTween(begin: 0, end: market.meiValue),
                                    duration: const Duration(milliseconds: 700),
                                    builder: (context, value, _){
                                      return MEIGauge(value: market.meiValue);
                                    },
                                    ),
                    
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(thickness: 0.6),
                                  ),
                    
                                  // FIXED HEIGHT
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 800),
                                    child: SizedBox(
                                      height: 220,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 16, left: 6),
                                        child: MeiLineChart(
                                        values: market.meiHistory,
                                        linecolor: getChartcolor(market.trendDirection),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(thickness: 0.6),
                                  ),

                                  /*if (market.alertMessage.isNotEmpty)
                                    AlertCard(
                                      level: market.alertLevel,
                                      title: market.alertTitle,
                                      message: market.alertMessage,
                                      factors: market.alertFactors,
                                    ),
                    
                                  //const SizedBox(height: 16),

                                  if (market.insightTitle.isNotEmpty)
                                    InsightsCard(
                                      insightTitle: market.insightTitle, 
                                      insightMessage: market.insightMessage, 
                                      insightType: market.insightType),*/

                                                                       

                    
                                  /*Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                    child: Column(
                                      children: [
                                        Text(market.Trend_explain),
                                        Text(market.Mom_explain),
                                        Text(Vol_explain),
                                      ],
                                    ),
                                    ),
                                  ),*/
                    
                                  Center(
                                    child: Text(
                                    getEmotion(market.meiValue),
                                    style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                    ),
                                  ),
                    
                                  const SizedBox(height: 8),
                    
                                  Center(
                                    child: Text(
                                    describeEmotion(market.meiValue),
                                    style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                    
                                  const SizedBox(height: 16),
                    
                                  /*Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        trend,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: getTrendColor(trend),
                                        ),
                                    ),
                                  ),*/
                    
                                  /*const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                  "LATEST HEADLINES 📰 📢 🚨",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                    
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: market.headlines.length,
                                    itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(Icons.article_outlined),
                                      title: Text(market.headlines[index]),
                                    );
                                    },
                                  ),*/
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