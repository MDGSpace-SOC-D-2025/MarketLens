import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketlens/market_state.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Market News 📰 📢 🚨"),
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
                : market.headlines.isEmpty
                    ? const Center(
                        child: Text(
                          "No news available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: market.headlines.length,
                        separatorBuilder: (_, __) =>
                            const Divider(thickness: 0.4),
                        itemBuilder: (context, index) {
                          final headline = market.headlines[index];
                          return ListTile(
                            leading:
                                const Icon(Icons.article_outlined),
                            title: Text(
                              headline,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
