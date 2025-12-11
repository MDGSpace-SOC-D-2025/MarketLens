import 'package:flutter/material.dart';

void main() {
  runApp(const MarketLensApp());
}

class MarketLensApp extends StatelessWidget {
  const MarketLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MarketLens',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MarketLens",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "MEI Gauge (Coming Soon..)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Latest Headlines",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(title: Text("Stocks rally as markets recover globally")),
                  ListTile(title: Text("Tech sector shows mixed signals")),
                  ListTile(title: Text("Oil prices fall amid global tensions")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
