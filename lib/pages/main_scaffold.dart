import 'package:flutter/material.dart';
import 'home_page.dart';
import 'insights_page.dart';
import 'news_page.dart';
import 'assistant_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final pages = const [
    HomePage(),
    InsightsPage(),
    NewsPage(),
    AssistantPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Overview",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: "Insights",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: "Assistant",
          ),
        ],
      ),
    );
  }
}
