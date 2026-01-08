import 'package:flutter/material.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: const Text("Insights"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Alerts + Insights will live here"),
      ),
    );
  }
}