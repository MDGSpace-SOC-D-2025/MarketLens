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
import 'package:marketlens/widgets/mei_sparkline.dart';
import 'package:marketlens/widgets/stock_search_delegate.dart';
import 'package:provider/provider.dart';



class HomePage extends StatelessWidget { 

  const HomePage({super.key});

      
  @override
  Widget build(BuildContext context) {

      final market = context.watch<MarketState>();  
      //Subscribes this widget to MarketState
      //When notifyListeners() is called:
      //HomePage rebuilds
      final meiHistory = market.meiHistory;
      final sparklineValues = meiHistory.length > 36
        ? meiHistory.sublist(meiHistory.length - 36)
        : meiHistory;



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
      
          
      body:  SafeArea(
        child: Column(              
              children: [               
                         
          
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
                    child: SingleChildScrollView( //entire column scrolls as one unit
                      physics: const AlwaysScrollableScrollPhysics(), 
//If the content does NOT exceed screen height:
//There is nothing to scroll
//Pull-to-refresh will NOT work

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

                                    MeiSparkline(
                                        values: sparklineValues,
                                        color: Colors.greenAccent,
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