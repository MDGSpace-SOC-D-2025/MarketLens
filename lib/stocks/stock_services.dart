import 'dart:convert';
import 'package:http/http.dart' as http;
import '../stocks/stock_model.dart';

class StockService {
  static const _baseUrl =
      'https://query1.finance.yahoo.com/v1/finance/search';

  Future<List<Stock>> searchStocks(String query) async {
    if (query.length < 2) return [];

    final uri = Uri.parse(
      '$_baseUrl?q=$query&quotesCount=10&newsCount=0',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Stock search failed');
    }

    final data = jsonDecode(response.body);
    final List quotes = data['quotes'] ?? [];

    return quotes
        .where((q) => q['symbol'] != null)
        .map((q) => Stock.fromYahoo(q))
        .toList();
  }
}


