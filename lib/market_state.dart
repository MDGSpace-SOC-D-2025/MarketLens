import 'dart:async';
import 'package:flutter/material.dart';
import '../mei_service.dart';
import 'package:marketlens/widgets/news_article.dart';


class MarketState extends ChangeNotifier {
  final MEIService meiService = MEIService();

  String stockCode = "AAPL";

  bool isLoading = false;
  String? error;

  
  int meiValue = 0;
  String trend = "--";
  List<int> meiHistory = [];

  List<NewsArticle> news = [];

  String trendDirection = "Unknown";
  int momentumScore = 0;
  String momentumStrength = "Unknown";
  String volatilityLevel = "Unknown";

  String alertTitle = "";
  String alertMessage = "";
  String alertLevel = "";
  List<dynamic> alertFactors = [];

  List<dynamic> insights = [];


  Timer? _timer;

  /// INITIAL FETCH
  Future<void> initialize() async {
    await fetchAll();
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => fetchAll(),
    );
  }

  Future<void> changeStock(String code) async {
    stockCode = code;
    await fetchAll();
  }

  Future<void> fetchAll() async {
    if (isLoading) return; //prevents overlapping request

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final stockData = await meiService.fetchJSON_StockMEIData(stockCode);
      final history = await meiService.fetchMEIHistory(stockCode);
      final trendData = await meiService.fetchMEItrend(stockCode);

      meiValue = stockData.value;
      trend = stockData.trend;
      news = stockData.news;

      meiHistory = history;

      final trendMap = trendData['Trend'] ?? {};
      final momentumMap = trendData['Momentum Score'] ?? {};
      final volatilityMap = trendData['Volatility Indicator'] ?? {};
      final alertMap = trendData['Alert'] ?? {};
      final insightMap = trendData['Insight'] ?? {};

      trendDirection = trendMap['direction'] ?? 'Unknown';

      momentumScore = momentumMap['value'] ?? 0;
      momentumStrength = momentumMap['strength'] ?? 'Unknown';

      volatilityLevel = volatilityMap['level'] ?? 'Unknown';

      alertTitle = alertMap['title'] ?? '';
      alertMessage = alertMap['message'] ?? '';
      alertLevel = alertMap['level'] ?? '';
      alertFactors = alertMap['factors'] ?? [];

      insights = trendData['Insight'] ?? [];


    } catch (e) {
      //error = "Failed to fetch market data";
      error = "Failed to fetch market data";
      debugPrint("FETCH ERROR: $e");
      
      
    }

    isLoading = false;
    notifyListeners();
  }

  void disposeState() {
    _timer?.cancel();
  }
}
