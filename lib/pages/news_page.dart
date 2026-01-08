import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market News"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Headlines list here"),
      ),
    );
  }
}
