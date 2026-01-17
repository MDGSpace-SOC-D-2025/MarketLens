import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketlens/market_state.dart';
import 'package:marketlens/widgets/alert_card.dart';
import 'package:marketlens/widgets/insights_card.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insights"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: market.isLoading
            ? const Center(child: CircularProgressIndicator())
            : market.error != null
                ? Center(
                    child: Text(
                      market.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      /// ALERT SECTION
                      if (market.alertMessage.isNotEmpty)
                        AlertCard(
                          level: market.alertLevel,
                          title: market.alertTitle,
                          message: market.alertMessage,
                          factors: market.alertFactors,
                        )
                      else
                        const Center(
                          child: Text(
                            "No active alerts",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                      const SizedBox(height: 16),

                      /// INSIGHTS SECTION
                      if (market.insights.isNotEmpty)
  ...market.insights.map((insight) {
  return InsightsCard(
    insightTitle: insight['title'],
    insightMessage: insight['message'],
    insightType: insight['type'],
    severity: insight['severity'],
    metrics: insight['metrics'],
  );
}).toList()

else
  const Center(
    child: Text(
      "No insights available",
      style: TextStyle(color: Colors.grey),
    ),
  )

                  
                    ],
                  ),
      ),
    );
  }
}














