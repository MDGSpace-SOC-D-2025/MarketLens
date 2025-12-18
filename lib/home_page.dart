import 'package:flutter/material.dart';
import 'widgets/mei_gauge.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MarketLens",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24,),
            MEIGauge(value: 72),
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