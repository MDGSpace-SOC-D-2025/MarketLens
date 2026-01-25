//MEIDATA
import 'package:marketlens/widgets/news_article.dart';

class MEIData {
  final int value;
  final String trend;

  MEIData({required this.value, required this.trend});

  factory MEIData.json_to_dart_obj(Map <String, dynamic> json) {

    return MEIData(value: json['mei'], trend: json['trend']);
    
  }

}

//STOCK SPECIFIC MEI DATA

class StockMEIData {
  final String code;
  final int value;
  final String trend;
  //final List<String> headlines;
  final List<NewsArticle> news;
  StockMEIData({
    required this.code,
    required this.value,
    required this.trend,
    required this.news,
  });

  factory StockMEIData.fromJson(Map<String, dynamic> json) {
    return StockMEIData(
    code: json['code'],
    value: json['mei'] is int ? json['mei'] : (json['mei'] as num).round(),
    trend: json['trend'] ?? "Uncertain",
    news: (json['news'] as List<dynamic>? ?? [])
        .map((e) => NewsArticle.fromJson(e))
        .toList(),
  );


  }
}
