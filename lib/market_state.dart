import 'dart:async';
import 'package:flutter/material.dart';
import '../mei_service.dart';

class MarketState extends ChangeNotifier {
  final MEIService meiService = MEIService();

  String stockCode = "AAPL";

  bool isLoading = false;
  String? error;

  
  int meiValue = 0;
  String trend = "--";
  List<int> meiHistory = [];

  List<dynamic> headlines = [];

  String trendDirection = "Unknown";
  int momentumScore = 0;
  String momentumStrength = "Unknown";
  String volatilityLevel = "Unknown";

  String alertTitle = "";
  String alertMessage = "";
  String alertLevel = "";
  List<dynamic> alertFactors = [];

  String insightTitle = "";
  String insightMessage = "";
  String insightType = "";

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
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final stockData = await meiService.fetchJSON_StockMEIData(stockCode);
      final history = await meiService.fetchMEIHistory(stockCode);
      final trendData = await meiService.fetchMEItrend(stockCode);

      meiValue = stockData.value;
      trend = stockData.trend;
      headlines = stockData.headlines;

      meiHistory = history;

      trendDirection = trendData['Trend']['direction'];
      momentumScore = trendData['Momentum Score']['value'];
      momentumStrength = trendData['Momentum Score']['strength'];
      volatilityLevel = trendData['Volatility Indicator']['level'];

      alertTitle = trendData['Alert']['title'];
      alertMessage = trendData['Alert']['message'];
      alertLevel = trendData['Alert']['level'];
      alertFactors = trendData['Alert']['factors'];

      insightTitle = trendData['Insight']['title'];
      insightMessage = trendData['Insight']['message'];
      insightType = trendData['Insight']['type'];

    } catch (e) {
      error = "Failed to fetch market data";
    }

    isLoading = false;
    notifyListeners();
  }

  void disposeState() {
    _timer?.cancel();
  }
}
